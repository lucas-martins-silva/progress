&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V02AD209 2.00.00.030}  /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02ad209 MUT}
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

/* Local Variable Definitions ---                                       */
/**** Miniflexibilizacao ****/
{cdp/cdcfgfin.i}
{include/i_dbvers.i}

/* Definiá∆o da temp-table tt-ext-portador */
&if "{&mgadm_version}" >= "2.02" &then 
    {cdp/cd0901f.i}
    def var l-enable as log.
&endif

def var c-cd0901                    as char   no-undo.

def var wh-cd0901                   as handle no-undo.

def var i-level   as int no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES portador
&Scoped-define FIRST-EXTERNAL-TABLE portador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR portador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS portador.nome-abrev portador.e-mail ~
portador.home-page portador.telefone portador.ramal portador.telefax ~
portador.ramal-fax portador.emissao-oc 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nome-abrev ~{&FP2}nome-abrev ~{&FP3}~
 ~{&FP1}e-mail ~{&FP2}e-mail ~{&FP3}~
 ~{&FP1}home-page ~{&FP2}home-page ~{&FP3}~
 ~{&FP1}telefone ~{&FP2}telefone ~{&FP3}~
 ~{&FP1}ramal ~{&FP2}ramal ~{&FP3}~
 ~{&FP1}telefax ~{&FP2}telefax ~{&FP3}~
 ~{&FP1}ramal-fax ~{&FP2}ramal-fax ~{&FP3}
&Scoped-define ENABLED-TABLES portador
&Scoped-define FIRST-ENABLED-TABLE portador
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-mold3 
&Scoped-Define DISPLAYED-FIELDS portador.nome-abrev portador.e-mail ~
portador.home-page portador.telefone portador.ramal portador.telefax ~
portador.ramal-fax portador.emissao-oc 
&Scoped-Define DISPLAYED-OBJECTS text-1 

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
DEFINE BUTTON bt-inform 
     LABEL "Outras Inform" 
     SIZE 15 BY 1.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(17)":U 
      VIEW-AS TEXT 
     SIZE 14.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.72 BY 9.04.

DEFINE RECTANGLE rt-mold3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.29 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     portador.nome-abrev AT ROW 1.25 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     portador.e-mail AT ROW 2.25 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     portador.home-page AT ROW 3.25 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     portador.telefone AT ROW 4.25 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     portador.ramal AT ROW 4.25 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     portador.telefax AT ROW 5.25 COL 26.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     portador.ramal-fax AT ROW 5.25 COL 58.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     portador.emissao-oc AT ROW 7.13 COL 32.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Carta", 1,
"Modem", 2,
"Fax", 3
          SIZE 34 BY 1.25
     bt-inform AT ROW 8.75 COL 28.43 HELP
          "Outras informaá‰es do portador"
     text-1 AT ROW 6.5 COL 29.57 NO-LABEL
     RECT-1 AT ROW 1 COL 1
     rt-mold3 AT ROW 6.83 COL 28.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.portador
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
         HEIGHT             = 9.13
         WIDTH              = 85.86.
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

/* SETTINGS FOR BUTTON bt-inform IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       bt-inform:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
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

&Scoped-define SELF-NAME bt-inform
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inform V-table-Win
ON CHOOSE OF bt-inform IN FRAME f-main /* Outras Inform */
DO:
&if "{&mgadm_version}" >= "2.02" &then  
    if  avail portador then do:
        find tt-ext-portador 
             where tt-ext-portador.cod-portador = portador.cod-portador
             and   tt-ext-portador.modalidade   = portador.modalidade no-error.
        if  not avail tt-ext-portador then do:
            create tt-ext-portador.
            assign tt-ext-portador.cod-portador           = portador.cod-portador
                   tt-ext-portador.modalidade             = portador.modalidade
                   tt-ext-portador.cod-emitente           = portador.cod-emitente
                   tt-ext-portador.ad-cliente             = portador.ad-cliente
                   tt-ext-portador.dias-car-descto        = portador.dias-car-descto
                   tt-ext-portador.dias-car-atraso-cred   = portador.dias-car-atraso-cred
                   tt-ext-portador.dias-car-juros         = portador.dias-car-juros
                   tt-ext-portador.vl-min-ad-cli-juros    = portador.vl-min-ad-cli-juros
                   tt-ext-portador.vl-min-ad-cli-descto   = portador.vl-min-ad-cli-descto
                   tt-ext-portador.vl-min-ad-cli-abat     = portador.vl-min-ad-cli-abat
                   tt-ext-portador.vl-min-ad-cli-despcart = portador.vl-min-ad-cli-despcart
                   tt-ext-portador.vl-min-ad-bco-juros    = portador.vl-min-ad-bco-juros
                   tt-ext-portador.vl-min-ad-bco-descto   = portador.vl-min-ad-bco-descto
                   tt-ext-portador.vl-min-ad-bco-abat     = portador.vl-min-ad-bco-abat           
                   tt-ext-portador.vl-min-ad-bco-atraso   = portador.vl-min-ad-bco-atraso
                   tt-ext-portador.gera-movto-dif         = portador.gera-movto-dif.
        end.    
        assign l-enable = no. 
        run cdp/cd0901f.w (input l-enable,
                           input-output table tt-ext-portador).
        
        for each tt-ext-portador:
            delete tt-ext-portador.
        end.                   
    end.    
    
&endif
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-field.i mgadm portador ramal 2}
assign portador.ramal:label in frame {&frame-name} = return-value
       portador.ramal-fax:label in frame {&frame-name} = return-value.
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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  {utp/ut-rtlbl.i mgadm portador emissao-oc text-1}  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {include/i-valid.i}

  if  not frame {&frame-name}:validate() then
      return 'adm-error':U.
  
  run pi-validate.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.
  &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    if avail conta-contab
    and avail portador then do:
       assign portador.ct-deb-princ = conta-contab.ct-codigo
              portador.sc-deb-princ = conta-contab.sc-codigo.
    end.  
  &ENDIF
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  disable all with frame {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-rtlbl.i mgadm portador emissao-oc text-1}    

    &if "{&mgadm_version}" >= "2.02" &then 
          vers_block:
          do:
              &if "{&mgadm_version}" = "2.02" &then
                  find first histor_exec_especial no-lock
                       where histor_exec_especial.cod_modul_dtsul = 'CRP'
                      and   histor_exec_especial.cod_prog_dtsul  = 'EMS_202_GERA_AD_BANCO' no-error.
                  if  not avail histor_exec_especial then
                      leave vers_block.  
              &endif
              
            assign i-level = 1.
            repeat while program-name(i-level) <> ?:       
                if  index(program-name(i-level),"cr0703.w") > 0 then
                    assign bt-inform:visible   in frame {&FRAME-NAME} = yes
                           bt-inform:sensitive in frame {&FRAME-NAME} = yes.
                assign i-level = i-level + 1.                    
            end.
         end.     
    &endif.                    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
    Purpose:Validar a viewer     
    Parameters:  <none>
    Notes: N∆o fazer assign aqui. Nesta procedure
    devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
    ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
                    
    {include/i-vldfrm.i}
                    
    run Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-cd0901).                   
    assign wh-cd0901 = widget-handle(c-cd0901).
                            
    if  input frame {&frame-name} portador.nome-abrev = "" then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 3258, 
                           input "").
        run select-page in wh-cd0901 (2).
        apply "entry" to portador.nome-abrev.
        return 'adm-error':U.
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



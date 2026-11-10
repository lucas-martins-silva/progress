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
{include/i-prgvrs.i V05IN111 2.00.00.008}  /*** 010008 ***/
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
/* Parameters Definitions ---                                           */
def new global shared var gr-estrutura as rowid no-undo.

/* Local Variable Definitions ---                                       */
def buffer b1-item for item. /*** Buffer para o item ***/
def buffer b2-item for item. /*** Buffer para o componente ***/

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES estrutura
&Scoped-define FIRST-EXTERNAL-TABLE estrutura


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estrutura.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estrutura.fantasma 
&Scoped-define ENABLED-TABLES estrutura
&Scoped-define FIRST-ENABLED-TABLE estrutura
&Scoped-Define ENABLED-OBJECTS fi-per-ppm rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS estrutura.qtd-item estrutura.fantasma ~
estrutura.fator-perda estrutura.es-codigo estrutura.it-codigo ~
estrutura.sequencia 
&Scoped-define DISPLAYED-TABLES estrutura
&Scoped-define FIRST-DISPLAYED-TABLE estrutura
&Scoped-Define DISPLAYED-OBJECTS tg-veiculo fi-per-ppm c-texto v-qtd-compon ~
c-descricao-item c-un-item c-descricao-comp c-un-comp 

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
DEFINE VARIABLE c-descricao-comp AS CHARACTER FORMAT "X(36)":U 
     VIEW-AS FILL-IN 
     SIZE 42.57 BY .88.

DEFINE VARIABLE c-descricao-item AS CHARACTER FORMAT "X(36)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(1)":U 
      VIEW-AS TEXT 
     SIZE 1 BY .67 NO-UNDO.

DEFINE VARIABLE c-un-comp AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE c-un-item AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE v-qtd-compon AS DECIMAL FORMAT "->>,>>9.9999999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.38.

DEFINE VARIABLE tg-veiculo AS LOGICAL INITIAL no 
     LABEL "Ve¡culo / Excipiente" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.29 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-veiculo AT ROW 2.75 COL 53.43
     fi-per-ppm AT ROW 2.67 COL 70 COLON-ALIGNED
     c-texto AT ROW 4.83 COL 34.57 COLON-ALIGNED NO-LABEL
     v-qtd-compon AT ROW 4.67 COL 17.14 COLON-ALIGNED
     c-descricao-item AT ROW 1.17 COL 22.86 COLON-ALIGNED NO-LABEL
     estrutura.qtd-item AT ROW 4.67 COL 36 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     estrutura.fantasma AT ROW 4.75 COL 75
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .75
     c-un-item AT ROW 1.17 COL 82.29 COLON-ALIGNED HELP
          "Unidade de medida do item." NO-LABEL
     estrutura.fator-perda AT ROW 4.67 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-descricao-comp AT ROW 3.67 COL 35 COLON-ALIGNED NO-LABEL
     c-un-comp AT ROW 3.67 COL 78 COLON-ALIGNED HELP
          "Unidade de medida do item." NO-LABEL
     estrutura.es-codigo AT ROW 3.67 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     estrutura.it-codigo AT ROW 1.17 COL 5 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     estrutura.sequencia AT ROW 2.67 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estrutura
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
         HEIGHT             = 4.92
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.es-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.fator-perda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.qtd-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estrutura.sequencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-veiculo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-qtd-compon IN FRAME f-main
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

{utp/ut-liter.i Qtd_Compon/Item * R}
assign v-qtd-compon:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Ve¡culo_/_Excipiente * R}
assign tg-veiculo:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "estrutura"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estrutura"}

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

  if  available estrutura then do:
      find b1-item where b1-item.it-codigo = estrutura.it-codigo no-lock no-error.
      find b2-item where b2-item.it-codigo = estrutura.es-codigo no-lock no-error.
              
      if  avail b1-item 
      and avail b2-item then do:
          assign c-descricao-comp = b2-item.desc-item 
                 c-un-comp        = b2-item.un 
                 c-descricao-item = b1-item.desc-item
                 c-un-item        = b1-item.un.
      end.
      
      &IF DEFINED (bf_man_sfc_lc) &THEN
            assign v-qtd-compon = estrutura.qtd-compon.
      &ELSE 
            assign v-qtd-compon = estrutura.quant-usada.
      &ENDIF
      
  end.
  
  assign c-texto = "/".
    
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    &IF DEFINED (bf_man_per_ppm) &THEN
    
        if avail b2-item               and
           param-global.modulo-per-ppm and
           b2-item.tipo-formula <> 0 then do:
            
/*             if b2-item.tipo-formula = 4 then                                            */
/*                 assign fi-per-ppm:visible   in frame {&frame-name} = false              */
/*                        tg-veiculo:visible   in frame {&frame-name} = true               */
/*                        tg-veiculo:sensitive in frame {&frame-name} = false              */
/*                        tg-veiculo:checked   in frame {&frame-name} = estrutura.veiculo. */
/*             else do:                                                                    */
                assign tg-veiculo:visible in frame {&frame-name} = false.
                case b2-item.tipo-formula:
                    when 2 then
                        run pi-formata-campo (fi-per-ppm:handle in frame {&frame-name}, true, false, b2-item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                    when 3 then
                        run pi-formata-campo (fi-per-ppm:handle, true, false, b2-item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                    /*Projeto Controle de Potˆncia - incluido o percentual de distribuicao do veiculo.*/
                    WHEN 4 THEN DO:
                        run pi-formata-campo (fi-per-ppm:handle, true, FALSE, 
                                              IF estrutura.veiculo THEN (
                                              &IF DEFINED(bf_man_207A) &THEN
                                                  estrutura.val-perc-distrib-veic
                                              &ELSE
                                                  DEC(dec(SUBSTRING(estrutura.char-1,6,12)) / 10000)
                                              &ENDIF
                                              ) ELSE 0 , "%":U, ">>9.9999":U).

                        assign tg-veiculo:visible        in frame {&frame-name} = true
                               tg-veiculo:checked        in frame {&frame-name} = estrutura.veiculo.
                    END.
                    otherwise
                        assign tg-veiculo:visible in frame {&frame-name} = false 
                               fi-per-ppm:visible in frame {&frame-name} = false.
                end case.
/*             end. */
        end.
        else do:
            assign tg-veiculo:visible in frame {&frame-name} = false 
                   fi-per-ppm:visible in frame {&frame-name} = false.
        END.
    
    &ENDIF


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  find first param-global no-lock.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  assign fi-per-ppm:visible in frame {&frame-name} = false
         tg-veiculo:visible in frame {&frame-name} = false.
  
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

  if avail estrutura then 
     assign gr-estrutura = rowid(estrutura).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campo V-table-Win 
PROCEDURE pi-formata-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle      as handle no-undo.
def input param pVisible     as log    no-undo.
def input param pSensitive   as log    no-undo.
def input param pScreenValue as dec    no-undo.
def input param pLabel       as char   no-undo.
def input param pFormat      as char   no-undo.

    if pVisible THEN DO:
        RUN utp/ut-liter.p (trim(pLabel), "*", "").
        assign pHandle:visible      = pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = string(pScreenValue)
               pHandle:label        = RETURN-VALUE no-error.
    END.
    else
        assign pHandle:visible = pVisible no-error.
    
return 'ok':u.

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
  {src/adm/template/snd-list.i "estrutura"}

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


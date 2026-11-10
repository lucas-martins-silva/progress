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
{include/i-prgvrs.i V59IN271 2.00.00.005 } /*** "010005" 01/09/2026 09:47:22 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V59IN271 MUT}
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

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var c-handle as char no-undo.
def var h-handle as handle no-undo.

{cdp/cdcfgman.i}   /* Vari vel preprocessador bf_man_sfc_lc */

def var i-nr-seq        like ped-item.nr-sequencia.
def var i-ressup-fabri  like item.ressup-fabri.
def var i-ressup        like item.ressup-fabri.
def var i-tempo-reserv  like estrutura.tempo-reserv.
def var i-contador      as integer no-undo.
def var i-resto         as integer no-undo.
def var da-data-aux     as date format "99/99/9999" no-undo.
def var i-pedido        like ped-venda.nr-pedcli no-undo.
def var i-cod-sit-aval  like ped-venda.cod-sit-aval no-undo.
def var i-cod-sit-ped   like ped-venda.cod-sit-ped no-undo.
def var i-tam-per       as integer no-undo.
def var c-it-codigo     like ord-prod.it-codigo no-undo.
def var c-cod-refer     like ord-prod.cod-refer no-undo.

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
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-prod.lote-serie ord-prod.dt-inicio ~
ord-prod.dt-termino ord-prod.prioridade ord-prod.dt-orig ~
ord-prod.num-ord-inv ord-prod.dt-emissao ord-prod.nome-abrev ~
ord-prod.emite-ordem ord-prod.cod-gr-cli ord-prod.emite-requis ~
ord-prod.nr-pedido ord-prod.nr-sequencia ord-prod.nr-entrega 
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 FILL-IN-1 
&Scoped-Define DISPLAYED-FIELDS ord-prod.lote-serie ord-prod.dt-inicio ~
ord-prod.dt-termino ord-prod.prioridade ord-prod.dt-orig ~
ord-prod.num-ord-inv ord-prod.dt-emissao ord-prod.nome-abrev ~
ord-prod.emite-ordem ord-prod.cod-gr-cli ord-prod.emite-requis ~
ord-prod.nr-pedido ord-prod.nr-sequencia ord-prod.nr-entrega ~
ord-prod.cod-prog-orig 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS c-cod-lista-compon c-cod-roteiro FILL-IN-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ord-prod.nr-entrega 
&Scoped-define ADM-ASSIGN-FIELDS ord-prod.nr-entrega 
&Scoped-define ADM-MODIFY-FIELDS ord-prod.nr-entrega 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
nr-req-sum|y|y|movind.ord-prod.nr-req-sum
nr-ord-produ|y|y|movind.ord-prod.nr-ord-produ
nr-ficha||y|movind.ord-prod.nr-ficha
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nr-req-sum,nr-ord-produ",
     Keys-Supplied = "nr-req-sum,nr-ord-produ,nr-ficha"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-lista-compon AS CHARACTER FORMAT "X(16)":U 
     LABEL "Lista Componentes" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-roteiro AS CHARACTER FORMAT "X(16)":U 
     LABEL "Roteiro" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "/" 
      VIEW-AS TEXT 
     SIZE 1 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.57 BY 9.46.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 9.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.lote-serie AT ROW 1.5 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     ord-prod.dt-inicio AT ROW 1.54 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ord-prod.dt-termino AT ROW 2.54 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ord-prod.prioridade AT ROW 2.54 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     ord-prod.dt-orig AT ROW 3.54 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ord-prod.num-ord-inv AT ROW 3.54 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     ord-prod.dt-emissao AT ROW 4.54 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ord-prod.cod-prog-orig AT ROW 4.54 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     ord-prod.nome-abrev AT ROW 5.5 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     ord-prod.emite-ordem AT ROW 5.67 COL 60
          VIEW-AS TOGGLE-BOX
          SIZE 17.29 BY .83
     ord-prod.cod-gr-cli AT ROW 6.5 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ord-prod.emite-requis AT ROW 6.83 COL 60
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .83
     ord-prod.nr-pedido AT ROW 7.5 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-cod-lista-compon AT ROW 8 COL 64.57 COLON-ALIGNED
     ord-prod.nr-sequencia AT ROW 8.5 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ord-prod.nr-entrega AT ROW 8.5 COL 33.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-cod-roteiro AT ROW 9 COL 64.57 COLON-ALIGNED
     FILL-IN-1 AT ROW 8.71 COL 32.14 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.13 COL 1.43
     RECT-2 AT ROW 1.13 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
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
         HEIGHT             = 9.75
         WIDTH              = 85.43.
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

/* SETTINGS FOR FILL-IN c-cod-lista-compon IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-lista-compon:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-roteiro IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-roteiro:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN ord-prod.nr-entrega IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME c-cod-lista-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-lista-compon V-table-Win
ON F5 OF c-cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    &IF DEFINED (bf_man_sfc_lc) &THEN
        {include/zoomvar.i &prog-zoom="inzoom/z01in481.w"  
                           &campo=c-cod-lista-compon
                           &campozoom=cod-lista-compon
                           &campo2=c-cod-roteiro
                           &campozoom2=cod-roteiro}
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-lista-compon V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-roteiro V-table-Win
ON F5 OF c-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
    &IF DEFINED (bf_man_sfc_lc) &THEN
        {include/zoomvar.i &prog-zoom="inzoom/z01in481.w"  
                           &campo=c-cod-lista-compon
                           &campozoom=cod-lista-compon
                           &campo2=c-cod-roteiro
                           &campozoom2=cod-roteiro}
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
    apply 'f5' to self.
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

    {utp/ut-liter.i Programa_Origem * R}
    assign ord-prod.cod-prog-orig:label in frame {&frame-name} = trim(return-value).

    &IF DEFINED (bf_man_sfc_lc) &THEN
        {utp/ut-liter.i Lista_Componentes * R}
        assign c-cod-lista-compon:label  in frame {&frame-name} = trim(return-value)
               c-cod-lista-compon:hidden in frame {&frame-name} = no.

        {utp/ut-liter.i Roteiro * R}
        assign c-cod-roteiro:label  in frame {&frame-name} = trim(return-value)
               c-cod-roteiro:hidden in frame {&frame-name} = no.

        if c-cod-lista-compon:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
        if c-cod-roteiro:load-mouse-pointer      ("image/lupa.cur") in frame {&frame-name} then. 
    &ELSE
        assign c-cod-lista-compon:hidden in frame {&frame-name} = yes
               c-cod-roteiro:hidden      in frame {&frame-name} = yes.
    &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'nr-req-sum':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = ord-prod
           &WHERE = "WHERE ord-prod.nr-req-sum eq INTEGER(key-value)"
       }
    WHEN 'nr-ord-produ':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = ord-prod
           &WHERE = "WHERE ord-prod.nr-ord-produ eq INTEGER(key-value)"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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

        
        /* Habilita e seta somente leitura, devido ao tamanho */
        ENABLE ord-prod.lote-serie WITH FRAME f-main.
        ASSIGN ord-prod.lote-serie:READ-ONLY IN FRAME f-main        = TRUE.
        
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

    &IF DEFINED (bf_man_sfc_lc) &THEN    
        if  avail ord-prod then 
            assign c-cod-lista-compon = ord-prod.cod-lista-compon
                   c-cod-roteiro      = ord-prod.cod-roteiro.
        else
            assign c-cod-lista-compon = ""
                   c-cod-roteiro      = "".
    &ENDIF

  /* Dispatch standard ADM method. */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */  


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
        
        /* Habilita e seta somente leitura, devido ao tamanho */
        ENABLE ord-prod.lote-serie WITH FRAME f-main.
        ASSIGN ord-prod.lote-serie:READ-ONLY IN FRAME f-main        = TRUE.
        
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "nr-req-sum" "ord-prod" "nr-req-sum"}
  {src/adm/template/sndkycas.i "nr-ord-produ" "ord-prod" "nr-ord-produ"}
  {src/adm/template/sndkycas.i "nr-ficha" "ord-prod" "nr-ficha"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "ord-prod"}

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


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
{include/i-prgvrs.i V53AD098 2.00.00.005}  /*** 010005 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v53ad098 MUT}
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

def var de-bonificacao-ant like emitente.bonificacao no-undo.
def var rw-emitente        as rowid                  no-undo.
def var c-texto            as char extent 2          no-undo.
def var h-window           as handle                 no-undo.
def var c-handle           as char                   no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.bonificacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}bonificacao ~{&FP2}bonificacao ~{&FP3}
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 RECT-4 RECT-2 
&Scoped-Define DISPLAYED-FIELDS emitente.bonificacao 
&Scoped-Define DISPLAYED-OBJECTS tb-log-libera-venda-sem-bonif ~
rs-ind-geracao-ped-bonif tb-log-fatur-ped-bonif ~
rs-ind-atua-bonif-canc-saldo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS tb-log-libera-venda-sem-bonif ~
rs-ind-geracao-ped-bonif tb-log-fatur-ped-bonif ~
rs-ind-atua-bonif-canc-saldo 
&Scoped-define List-4 rs-ind-geracao-ped-bonif 

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
DEFINE VARIABLE c-texto-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20.14 BY .67 NO-UNDO.

DEFINE VARIABLE rs-ind-atua-bonif-canc-saldo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "N∆o Cancela", 1,
"Cancela na Mesma Proporá∆o", 2,
"Cancela Totalmente", 3
     SIZE 25.72 BY 2.63 NO-UNDO.

DEFINE VARIABLE rs-ind-geracao-ped-bonif AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 24.14 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 2.79.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 3.71.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.14 BY 2.67.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 9.5.

DEFINE VARIABLE tb-log-fatur-ped-bonif AS LOGICAL INITIAL no 
     LABEL "Fatur Bonif ap¢s Fatur Total Venda" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.14 BY .88 NO-UNDO.

DEFINE VARIABLE tb-log-libera-venda-sem-bonif AS LOGICAL INITIAL no 
     LABEL "Libera Venda sem Bonif" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.43 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     emitente.bonificacao AT ROW 1.5 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     tb-log-libera-venda-sem-bonif AT ROW 3.42 COL 42
     rs-ind-geracao-ped-bonif AT ROW 3.71 COL 6.43 NO-LABEL
     tb-log-fatur-ped-bonif AT ROW 4.42 COL 42
     rs-ind-atua-bonif-canc-saldo AT ROW 7.17 COL 6.43 NO-LABEL
     c-texto-1 AT ROW 2.75 COL 3.29 COLON-ALIGNED NO-LABEL
     c-texto-2 AT ROW 6.13 COL 3.72 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1.04 COL 1
     RECT-1 AT ROW 3 COL 2.57
     RECT-4 AT ROW 3 COL 38.43
     RECT-2 AT ROW 6.38 COL 2.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 9.75
         WIDTH              = 73.43.
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

/* SETTINGS FOR FILL-IN c-texto-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-texto-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RADIO-SET rs-ind-atua-bonif-canc-saldo IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-ind-geracao-ped-bonif IN FRAME f-main
   NO-ENABLE 3 4                                                        */
/* SETTINGS FOR TOGGLE-BOX tb-log-fatur-ped-bonif IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tb-log-libera-venda-sem-bonif IN FRAME f-main
   NO-ENABLE 3                                                          */
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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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

  /* Code placed here will execute AFTER standard behavior.    */
  tb-log-fatur-ped-bonif:screen-value in frame {&frame-name} = "".

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

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    assign  input frame {&frame-name} rs-ind-geracao-ped-bonif
            input frame {&frame-name} tb-log-fatur-ped-bonif
            input frame {&frame-name} rs-ind-atua-bonif-canc-saldo
            input frame {&frame-name} tb-log-libera-venda-sem-bonif.


    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if avail emitente then do:
       find first dist-emitente 
            where dist-emitente.cod-emitente = emitente.cod-emitente exclusive-lock no-error.
       if avail dist-emitente then  
          assign dist-emitente.ind-geracao-ped-bonif      = rs-ind-geracao-ped-bonif
                 dist-emitente.log-fatur-ped-bonif        = tb-log-fatur-ped-bonif
                 dist-emitente.ind-atua-bonif-canc-saldo  = rs-ind-atua-bonif-canc-saldo
                 dist-emitente.log-libera-venda-sem-bonif = tb-log-libera-venda-sem-bonif.

       if de-bonificacao-ant <> emitente.bonificacao then do:

          if param-global.modulo-09 then do: /* se modulo descontos/bonificaá‰es implantado */

            {utp/ut-field.i mgdis canal-cliente bonificacao 1} c-texto[1] = trim(return-value).
            {utp/ut-liter.i Carteira_de_Pedidos MBN c}    c-texto[2] = trim(return-value).
            run utp/ut-msgs.p (input "show":U, input 17756, input c-texto[1] + "~~" + c-texto[2]).

            if return-value = "yes" then 

               /* exportaá∆o da bonificaá∆o para carteira de pedidos */
               run pi-exportacao-carteira-pedidos.

          end. /* fim modulo-09 */

          if param-global.modulo-10      and
             par-preco.tp-preco-min = 1  then do:

            /************************************************************************
            Caso operaá∆o de manutená∆o tenha sido com sucesso, retornar essa msg 
            para o usuario : 
            MsG: ê necess†rio recalcular os preáos minimos no modulo de Administraá∆o
            de Preáos de Vendas
            ************************************************************************/ 

            run utp/ut-msgs.p (input "show":U, input 17737, input '').

          end. /* fim modulo-10 */ 
       end. /* de-bonificacao-ant */              

    end. /*avail emitente*/

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

  if avail emitente then do:
     find first dist-emitente 
          where dist-emitente.cod-emitente = emitente.cod-emitente no-lock no-error.
     if avail dist-emitente then  
        assign rs-ind-geracao-ped-bonif      = dist-emitente.ind-geracao-ped-bonif
               tb-log-fatur-ped-bonif        = dist-emitente.log-fatur-ped-bonif
               rs-ind-atua-bonif-canc-saldo  = dist-emitente.ind-atua-bonif-canc-saldo
               tb-log-libera-venda-sem-bonif = dist-emitente.log-libera-venda-sem-bonif.
     else
        assign rs-ind-geracao-ped-bonif      = 0
               tb-log-fatur-ped-bonif        = no
               rs-ind-atua-bonif-canc-saldo  = 0
               tb-log-libera-venda-sem-bonif = no.
  end. /*avail emitente*/

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
    if adm-new-record = yes then
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

    /* busca tabela com informaá‰es de parametros */
    find first param-global no-lock no-error.
    find first para-ped     no-lock no-error.
    find first par-preco  where 
               par-preco.cod-estabel = para-ped.estab-padrao no-lock no-error.


     RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-handle).
     assign h-window = widget-handle(c-handle). 

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

      {utp/ut-liter.i Geraá∆o_Bonificaá∆o MBN c}
      assign c-texto-1:screen-value in frame {&frame-name} = trim(return-value).

      {utp/ut-liter.i Atual_Bonific_Cancel_Saldo MBN c}
      assign c-texto-2:screen-value in frame {&frame-name} = trim(return-value).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exportacao-carteira-pedidos V-table-Win 
PROCEDURE pi-exportacao-carteira-pedidos :
/*------------------------------------------------------------------------------
  Purpose: exportaá∆o da bonificaá∆o para carteira de pedidos    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    if avail emitente then 
       assign rw-emitente = rowid(emitente). 

    run pi-habilita-desabilita-container in h-window ( input no ).

    run cdp/cd1510c.w ( input de-bonificacao-ant,
                        input rw-emitente  ).

    run pi-habilita-desabilita-container in h-window ( input yes ).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose: habilitar os campos de tela.    
  Parameters:  nono.
------------------------------------------------------------------------------*/
 assign de-bonificacao-ant = input frame {&frame-name} emitente.bonificacao
        rs-ind-geracao-ped-bonif:sensitive in frame {&frame-name}      = yes
        tb-log-fatur-ped-bonif:sensitive in frame {&frame-name}        = yes
        rs-ind-atua-bonif-canc-saldo:sensitive in frame {&frame-name}  = yes
        tb-log-libera-venda-sem-bonif:sensitive in frame {&frame-name} = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

 if input frame {&frame-name} emitente.bonificacao > 100 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, input 507, input '').
    apply "entry" to emitente.bonificacao in frame {&frame-name}. 
    return 'ADM-ERROR':U. 
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
  {src/adm/template/snd-list.i "emitente"}

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


  if p-state = "update-begin" then 
     run pi-habilita-campos.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



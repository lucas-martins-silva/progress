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
{include/i-prgvrs.i V02IN666 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN666 MUT}
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

def var l-pendente as logical.
def var h-acomp          as handle  no-undo.
def var i-nr-processo like ordem-compra.nr-processo no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-aprov
&Scoped-define FIRST-EXTERNAL-TABLE param-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-aprov.aprov-total-solic ~
param-aprov.tipo-total-solic param-aprov.aprov-total-requis ~
param-aprov.tipo-total-requis param-aprov.aprov-total-pedido ~
param-aprov.tipo-total-pedido param-aprov.aprov-total-proc ~
param-aprov.tipo-total-proc param-aprov.tipo-total-cont 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES param-aprov
&Scoped-define FIRST-ENABLED-TABLE param-aprov
&Scoped-Define ENABLED-OBJECTS rt-mold-14 rt-mold-13 rt-mold-12 rt-mold-11 ~
rt-mold-10 rt-mold-9 
&Scoped-Define DISPLAYED-FIELDS param-aprov.aprov-total-solic ~
param-aprov.tipo-total-solic param-aprov.aprov-total-requis ~
param-aprov.tipo-total-requis param-aprov.aprov-total-pedido ~
param-aprov.tipo-total-pedido param-aprov.aprov-total-proc ~
param-aprov.tipo-total-proc param-aprov.tipo-total-cont 

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
DEFINE RECTANGLE rt-mold-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.29 BY 1.25.

DEFINE RECTANGLE rt-mold-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.29 BY 1.25.

DEFINE RECTANGLE rt-mold-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.29 BY 1.25.

DEFINE RECTANGLE rt-mold-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.29 BY 1.25.

DEFINE RECTANGLE rt-mold-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.29 BY 1.25.

DEFINE RECTANGLE rt-mold-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.86 BY 11.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-aprov.aprov-total-solic AT ROW 3.88 COL 18.57
          VIEW-AS TOGGLE-BOX
          SIZE 21.43 BY .83
     param-aprov.tipo-total-solic AT ROW 3.88 COL 45.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lota‡Æo", 1,
"Faixa", 2
          SIZE 19.57 BY .83
     param-aprov.aprov-total-requis AT ROW 5.25 COL 18.57
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .83
     param-aprov.tipo-total-requis AT ROW 5.25 COL 45.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lota‡Æo", 1,
"Faixa", 2
          SIZE 19.57 BY .83
     param-aprov.aprov-total-pedido AT ROW 6.63 COL 18.57
          VIEW-AS TOGGLE-BOX
          SIZE 17.72 BY .83
     param-aprov.tipo-total-pedido AT ROW 6.63 COL 45.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lota‡Æo", 1,
"Faixa", 2
          SIZE 19.57 BY .83
     param-aprov.aprov-total-proc AT ROW 8 COL 18.57
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     param-aprov.tipo-total-proc AT ROW 8 COL 45.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lota‡Æo", 1,
"Faixa", 2
          SIZE 19.57 BY .83
     param-aprov.tipo-total-cont AT ROW 9.38 COL 45.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lota‡Æo", 1,
"Faixa", 2
          SIZE 19.57 BY .83
     "Controle Contratos" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 9.38 COL 21.29
     rt-mold-14 AT ROW 9.13 COL 17.29
     rt-mold-13 AT ROW 7.75 COL 17.29
     rt-mold-12 AT ROW 6.38 COL 17.29
     rt-mold-11 AT ROW 5 COL 17.29
     rt-mold-10 AT ROW 3.63 COL 17.29
     rt-mold-9 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-aprov
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
         HEIGHT             = 11.92
         WIDTH              = 82.
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

&Scoped-define SELF-NAME param-aprov.aprov-total-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprov-total-pedido V-table-Win
ON VALUE-CHANGED OF param-aprov.aprov-total-pedido IN FRAME f-main /* Pedido Compra */
DO:

    assign param-aprov.tipo-total-pedido:sensitive in frame {&frame-name} =
           param-aprov.aprov-total-pedido:checked  in frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprov-total-proc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprov-total-proc V-table-Win
ON VALUE-CHANGED OF param-aprov.aprov-total-proc IN FRAME f-main /* Processo Compra */
DO:

    assign param-aprov.tipo-total-proc:sensitive   in frame {&frame-name} = 
           param-aprov.aprov-total-proc:checked    in frame {&frame-name}.           
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprov-total-requis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprov-total-requis V-table-Win
ON VALUE-CHANGED OF param-aprov.aprov-total-requis IN FRAME f-main /* Requisi‡Æo Estoque */
DO:

    assign param-aprov.tipo-total-requis:sensitive in frame {&frame-name} =
           param-aprov.aprov-total-requis:checked  in frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprov-total-solic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprov-total-solic V-table-Win
ON VALUE-CHANGED OF param-aprov.aprov-total-solic IN FRAME f-main /* Solicita‡Æo Compra */
DO:     
    assign param-aprov.tipo-total-solic:sensitive  in frame {&frame-name} =
           param-aprov.aprov-total-solic:checked   in frame {&frame-name}.
  
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
  {src/adm/template/row-list.i "param-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-aprov"}

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    find first param-compra exclusive-lock no-error.
    if available param-compra then do:
        if param-aprov.aprov-total-solic  then assign substring(param-compra.char-2, 1,3) = "Sim":U.
                                          else assign substring(param-compra.char-2, 1,3) = "NÆo":U.
        if param-aprov.aprov-total-requis then assign substring(param-compra.char-2, 4,3) = "Sim":U.
                                          else assign substring(param-compra.char-2, 4,3) = "NÆo":U.
        if param-aprov.aprov-total-pedido then assign substring(param-compra.char-2, 7,3) = "Sim":U.
                                          else assign substring(param-compra.char-2, 7,3) = "NÆo":U.
        if param-aprov.aprov-total-proc   then assign substring(param-compra.char-2,18,3) = "Sim":U.
                                          else assign substring(param-compra.char-2,18,3) = "NÆo":U.
        assign substring(param-compra.char-2,10,1) = string(param-aprov.tipo-total-solic, "9")
               substring(param-compra.char-2,11,1) = string(param-aprov.tipo-total-requis,"9")
               substring(param-compra.char-2,12,1) = string(param-aprov.tipo-total-pedido,"9")
               substring(param-compra.char-2,16,1) = string(param-aprov.tipo-total-proc,  "9")
               substring(param-compra.char-2,17,1) = string(param-aprov.tipo-total-cont,  "9").
    end.
    release param-compra.

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

    disable param-aprov.aprov-total-solic
            param-aprov.aprov-total-requis
            param-aprov.aprov-total-pedido
            param-aprov.aprov-total-proc
            param-aprov.tipo-total-solic
            param-aprov.tipo-total-requis
            param-aprov.tipo-total-pedido
            param-aprov.tipo-total-proc
            param-aprov.tipo-total-cont 
            with frame {&frame-name}.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-total V-table-Win 
PROCEDURE pi-habilita-total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-solicitacao as logical no-undo.
    def input parameter p-requisicao  as logical no-undo.
    def input parameter p-pedido      as logical no-undo.
    def input parameter p-processo    as logical no-undo.
    def input parameter p-contrato    as logical no-undo.
    
    assign param-aprov.aprov-total-solic:sensitive  in frame {&frame-name} = p-solicitacao
           param-aprov.aprov-total-requis:sensitive in frame {&frame-name} = p-requisicao
           param-aprov.aprov-total-pedido:sensitive in frame {&frame-name} = p-pedido
           param-aprov.aprov-total-proc:sensitive   in frame {&frame-name} = p-processo.

    assign param-aprov.tipo-total-solic:sensitive   in frame {&frame-name} = p-solicitacao
           param-aprov.tipo-total-requis:sensitive  in frame {&frame-name} = p-requisicao
           param-aprov.tipo-total-pedido:sensitive  in frame {&frame-name} = p-pedido
           param-aprov.tipo-total-proc:sensitive    in frame {&frame-name} = p-processo
           param-aprov.tipo-total-cont:sensitive    in frame {&frame-name} = p-contrato.
    
    if not param-aprov.aprov-total-solic:sensitive in frame {&frame-name} then
        assign param-aprov.aprov-total-solic:checked in frame {&frame-name} = no.
    if not param-aprov.aprov-total-requis:sensitive in frame {&frame-name} then
        assign param-aprov.aprov-total-requis:checked in frame {&frame-name} = no.
    if not param-aprov.aprov-total-pedido:sensitive in frame {&frame-name} then
        assign param-aprov.aprov-total-pedido:checked in frame {&frame-name} = no.
    if not param-aprov.aprov-total-proc:sensitive in frame {&frame-name} then
        assign param-aprov.aprov-total-proc:checked in frame {&frame-name} = no.

    if not param-aprov.aprov-total-solic:checked in frame {&frame-name} then
        assign param-aprov.tipo-total-solic:sensitive in frame {&frame-name} = no.
    if not param-aprov.aprov-total-requis:checked in frame {&frame-name} then
        assign param-aprov.tipo-total-requis:sensitive in frame {&frame-name} = no.
    if not param-aprov.aprov-total-pedido:checked in frame {&frame-name} then
        assign param-aprov.tipo-total-pedido:sensitive in frame {&frame-name} = no.
    if not param-aprov.aprov-total-proc:checked in frame {&frame-name} then
        assign param-aprov.tipo-total-proc:sensitive in frame {&frame-name} = no.

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
    
    /* Se alterado o tipo de aprova‡Æo, verifica se existem pendˆncias de aprova‡Æo */
    if avail param-aprov and
       input frame {&frame-name} param-aprov.aprov-total-solic <> param-aprov.aprov-total-solic then do:
       run utp/ut-acomp.p persistent set h-acomp.
       run pi-inicializar in h-acomp (input "Verificando Pendˆncias de Aprova‡Æo").
       run pi-desabilita-cancela in h-acomp.  
       {utp/ut-liter.i Solicita‡Æo}
       
       assign l-pendente = no.
       solicitacao:
       for each requisicao
          where requisicao.tp-requis = 2 no-lock:
          for each it-requisicao 
             where it-requisicao.nr-requisicao = requisicao.nr-requisicao
             and   it-requisicao.estado = 2 no-lock:             
             run pi-acompanhar in h-acomp (input return-value + ": " +
                                           string(requisicao.nr-requisicao)). 
             run pi-verifica-pend (input 1, input rowid(it-requisicao), output l-pendente).
             if l-pendente then leave solicitacao.
          end.
       end.     
       run pi-finalizar in h-acomp.
       if l-pendente then do :
          {utp/ut-liter.i Solicita‡Æo_de_Compra}
          run utp/ut-msgs.p (input "show", input 26203, input return-value + "~~" + 
                             string(requisicao.nr-requisicao)).
          return "adm-error":U.
       end.
    end.    
    
    if avail param-aprov and
       input frame {&frame-name} param-aprov.aprov-total-requis <> param-aprov.aprov-total-requis then do:
       run utp/ut-acomp.p persistent set h-acomp.
       run pi-inicializar in h-acomp (input "Verificando Pendˆncias de Aprova‡Æo").
       run pi-desabilita-cancela in h-acomp.  
       {utp/ut-liter.i Requisi‡Æo}

       assign l-pendente = no.
       requisicao:
       for each requisicao
          where requisicao.tp-requis = 1 no-lock:
          run pi-acompanhar in h-acomp (input return-value + ": " +
                                        string(requisicao.nr-requisicao)).
          for each it-requisicao 
             where it-requisicao.nr-requisicao = requisicao.nr-requisicao
             and   it-requisicao.estado = 2 no-lock:             
             run pi-verifica-pend (input 2, input rowid(it-requisicao), output l-pendente).
             if l-pendente then leave requisicao.
          end.
       end.     
       run pi-finalizar in h-acomp.       
       if l-pendente then do :
          {utp/ut-liter.i Requisi‡Æo_de_Estoque}
          run utp/ut-msgs.p (input "show", input 26203, input return-value + "~~" + 
                             string(requisicao.nr-requisicao)).
          return "adm-error":U.
       end.
    end.    
    
    if avail param-aprov and
       input frame {&frame-name} param-aprov.aprov-total-pedido <> param-aprov.aprov-total-pedido then do:
       run utp/ut-acomp.p persistent set h-acomp.
       run pi-inicializar in h-acomp (input "Verificando Pendˆncias de Aprova‡Æo").
       run pi-desabilita-cancela in h-acomp.  
       {utp/ut-liter.i Pedido}

       assign l-pendente = no.
       for each ordem-compra
          where ordem-compra.num-pedido <> 0 no-lock:
          find pedido-compr where
               pedido-compr.num-pedido = ordem-compra.num-pedido
               no-lock no-error.
          if avail pedido-compr then do:     
             run pi-acompanhar in h-acomp (input return-value + ": " +
                                           string(pedido-compr.num-pedido)).
             if  pedido-compr.emergencial then
                 run pi-verifica-pend (input 6, input rowid(ordem-compra), output l-pendente).
             else
                 run pi-verifica-pend (input 4, input rowid(ordem-compra), output l-pendente).  
          end.    
          if l-pendente then leave.                               
       end.
       run pi-finalizar in h-acomp.
       if l-pendente then do :
          {utp/ut-liter.i Pedido_de_Compra}
          run utp/ut-msgs.p (input "show", input 26203, input return-value + "~~" + 
                             string(ordem-compra.num-pedido)).
          return "adm-error":U.
       end.
    end.   

    if avail param-aprov and
       input frame {&frame-name} param-aprov.aprov-total-proc <> param-aprov.aprov-total-proc then do:
       run utp/ut-acomp.p persistent set h-acomp.
       run pi-inicializar in h-acomp (input "Verificando Pendˆncias de Aprova‡Æo").
       run pi-desabilita-cancela in h-acomp.  
       {utp/ut-liter.i Processo}
       
       assign l-pendente = no.
       for each ordem-compra
          where ordem-compra.nr-processo <> 0 no-lock:
          for each cotacao-item 
             where cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                   cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF no-lock:
             run pi-acompanhar in h-acomp (input return-value + ": " +
                                           string(ordem-compra.nr-processo)).    
             run pi-verifica-pend (input 7, input rowid(cotacao-item), output l-pendente). 
             assign i-nr-processo = ordem-compra.nr-processo.
             if l-pendente then leave.                               
          end.    
       end.
       
       run pi-finalizar in h-acomp.
       if l-pendente then do :          
          {utp/ut-liter.i Processo_de_Compra}
          run utp/ut-msgs.p (input "show", input 26203, input return-value  + "~~" + 
                             string(i-nr-processo)).
          return "adm-error":U.
       end.
    end.       
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-pend V-table-Win 
PROCEDURE pi-verifica-pend :
/*************************************************************************
**   Parƒmetros:  I-tipo - Tipo de documento    1-Solicita‡Æo
**                                              2-Requisi‡Æo 
**                                              3-Cota‡Æo 
**                                              4-Pedido 
**                                              5-Solicita‡Æo Cota‡Æo
**                                              6-Pedido Emergencial
**                                              7-Processo Compras
**                                              8-Contrato Fornec
**                                              9-Manuten‡Æo Industrial
**
**                R-documento - Rowid do documento
**
**                p-pendente - Retorna yes se existe documentos pendentes
**
**************************************************************************/

def input  parameter i-tipo      as integer no-undo.
def input  parameter r-documento as rowid   no-undo.
def output parameter p-pendente  as logical no-undo.

/**  Melhorias
**/
if  not avail param-compra then
    find first param-compra no-lock no-error.

if i-tipo  = 1 then do:
    /**
    ***   Solicita‡Æo
    **/
    if  r-documento <> ? then do:
        find it-requisicao where
            rowid(it-requisicao) = r-documento
            no-lock no-error.
        
        if  input frame {&frame-name} param-aprov.aprov-total-solic then 
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo                      and
                doc-pend-aprov.nr-requisicao = it-requisicao.nr-requisicao and
                &if defined(bf_mat_aprova_eletronica) &then
                    doc-pend-aprov.it-codigo = it-requisicao.it-codigo     and
                    doc-pend-aprov.sequencia = it-requisicao.sequencia     and
                &endif
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no))
                no-lock no-error.
        else
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo                      and
                doc-pend-aprov.nr-requisicao = it-requisicao.nr-requisicao and
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no)) and
                doc-pend-aprov.aprov-total   = yes
                no-lock no-error.
        
        assign p-pendente = available doc-pend-aprov.
    end.
end.
else
if  i-tipo = 2 then do:
    /**
    ***   Requisi‡Æo
    **/
    if r-documento <> ? then do:
        find it-requisicao where
            rowid(it-requisicao) = r-documento
            no-lock no-error.
        
        if  input frame {&frame-name} param-aprov.aprov-total-requis then 
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo                      and
                doc-pend-aprov.nr-requisicao = it-requisicao.nr-requisicao and
                &if defined(bf_mat_aprova_eletronica) &then
                    doc-pend-aprov.it-codigo = it-requisicao.it-codigo     and
                    doc-pend-aprov.sequencia = it-requisicao.sequencia     and
                &endif
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no))
                no-lock no-error.
        else
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo                      and
                doc-pend-aprov.nr-requisicao = it-requisicao.nr-requisicao and
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no)) and
                doc-pend-aprov.aprov-total   = yes
                no-lock no-error.
        
        assign p-pendente = available doc-pend-aprov.
    end.
end.
else if i-tipo = 4 or
    i-tipo = 6 then do:
    /**
    ***   Pedido
    **/
    if  r-documento <> ? then do:
        find ordem-compra where
            rowid(ordem-compra) = r-documento
            no-lock no-error.
        if  input frame {&frame-name} param-aprov.aprov-total-pedido then /* se mudar p/ total */
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo and
                doc-pend-aprov.numero-ordem  = ordem-compra.numero-ordem and
                doc-pend-aprov.num-pedido    = ordem-compra.num-pedido   and
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no))
                no-lock no-error.
        else /* se mudar para item */
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo and
                doc-pend-aprov.num-pedido    = ordem-compra.num-pedido   and
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no)) and
                doc-pend-aprov.aprov-total   = yes
                no-lock no-error.
        
        assign p-pendente = available doc-pend-aprov.
    end.
end.
else if i-tipo = 7 then do:
    /** 
    ***   Processo
    **/ 
    if  r-documento <> ? then do:
        find cotacao-item where
            rowid(cotacao-item) = r-documento
            no-lock no-error.
        find ordem-compra where ordem-compra.numero-ordem = cotacao-item.numero-ordem no-lock no-error.
        
        if   NOT param-aprov.aprov-total-proc then do: /* mudar para item */
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo                    and
                doc-pend-aprov.numero-ordem  = cotacao-item.numero-ordem and
                doc-pend-aprov.it-codigo     = cotacao-item.it-codigo    and
                doc-pend-aprov.cod-emitente  = cotacao-item.cod-emitente and
                doc-pend-aprov.sequencia     = cotacao-item.seq-cotac    and
                doc-pend-aprov.int-1         = ordem-compra.nr-processo  and /* processo */
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no))
                no-lock no-error.
        end.
        else do: /* mudar para total */
            find first doc-pend-aprov where
                doc-pend-aprov.ind-tip-doc   = i-tipo                    and
                doc-pend-aprov.numero-ordem  = cotacao-item.numero-ordem and
                doc-pend-aprov.int-1         = ordem-compra.nr-processo  and /* processo */
              ((doc-pend-aprov.ind-situacao  = 1  or 
                doc-pend-aprov.ind-situacao  = 3) or
               (doc-pend-aprov.ind-situacao  = 2  and doc-pend-aprov.sit-aprov = no))
                no-lock no-error.
        end.                    
        
        assign p-pendente = avail doc-pend-aprov.
    end.
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
  {src/adm/template/snd-list.i "param-aprov"}

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



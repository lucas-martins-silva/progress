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
{include/i-prgvrs.i V11AD268 2.00.00.021 } /*** "010021" 10/10/2024 14:20:32 ***/
{include/rowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V11AD268 MUT}
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
def var v-row-parent    as rowid no-undo.
def var r-param         as rowid no-undo.
def var i-parc          as int   no-undo.
def var c-nome          as char  no-undo.
def var l-internacional as log no-undo.
def var l-e-commerce    as log no-undo.

DEFINE BUFFER bfTransporte FOR transporte.

/* Vari†vel Global do EMS 5 para o Zoom de Parceiro EDI */
def new global shared var v_rec_parcei_edi AS {&ROWID} 
    &IF {&ROWID_READY} = NO &THEN             
        format ">>>>>>9" initial ? 
    &ENDIF
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES transporte
&Scoped-define FIRST-EXTERNAL-TABLE transporte


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR transporte.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS transporte.log-envia-dados transporte.log-EDI ~
transporte.cdn-parcei-EDI transporte.des-ident-transp transporte.cod-transp-ecommerce
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cdn-parcei-EDI ~{&FP2}cdn-parcei-EDI ~{&FP3}~
 ~{&FP1}des-ident-transp ~{&FP2}des-ident-transp ~{&FP3}
&Scoped-define ENABLED-TABLES transporte
&Scoped-define FIRST-ENABLED-TABLE transporte
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS transporte.log-envia-dados ~
transporte.log-EDI transporte.cdn-parcei-EDI transporte.des-ident-transp transporte.cod-transp-ecommerce

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
nome-abrev|y|y|mgadm.transporte.nome-abrev
cod-transp|y|y|mgadm.transporte.cod-transp
cod-emitente||y|mgadm.transporte.cod-emitente
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nome-abrev,cod-transp",
     Keys-Supplied = "nome-abrev,cod-transp,cod-emitente"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 7.79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     transporte.log-envia-dados AT ROW 2.25 COL 37.29
          VIEW-AS TOGGLE-BOX
          SIZE 17.43 BY .71
     transporte.log-EDI AT ROW 3.13 COL 37.29
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
     transporte.cdn-parcei-EDI AT ROW 4 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     transporte.des-ident-transp AT ROW 5 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     transporte.cod-transp-ecommerce AT ROW 6 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 48 BY .88  
     rt-mold AT ROW 1.08 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.transporte
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
         HEIGHT             = 7.96
         WIDTH              = 86.29.
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

&Scoped-define SELF-NAME transporte.cdn-parcei-EDI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cdn-parcei-EDI V-table-Win
ON F5 OF transporte.cdn-parcei-EDI IN FRAME f-main /* Parceiro EDI */
DO:
     assign l-implanta = yes.
     
    /* Retirar esta validaá∆o do coment†rio qdo tiver um ambiente EMS 2.03 + EMS 5.03 + EDI para teste */ 
     
    /*
    if  search("prgint/edu/edu001ka.r") = ? and search("prgint/edu/edu001ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/edu/edu001ka.p"
                view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/edu/edu001ka.p /*prg_sea_parcei_edi*/.

    if  v_rec_parcei_edi <> ? then do:
        run prgint/edu/edu721za.py
                (input 1, 
                 input-output v_rec_parcei_edi, 
                 input-output i-parc , 
                 output       c-nome).
    
        if  i-parc <> 0 then 
            assign transporte.cdn-parcei-edi:screen-value in frame {&frame-name} = string(i-parc).
    
    end.
    */
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cdn-parcei-EDI V-table-Win
ON MOUSE-SELECT-DBLCLICK OF transporte.cdn-parcei-EDI IN FRAME f-main /* Parceiro EDI */
DO:
     assign l-implanta = yes.
   
     /*
    if  search("prgint/edu/edu001ka.r") = ? and search("prgint/edu/edu001ka.p") = ? then do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/edu/edu001ka.p"
                view-as alert-box error buttons ok.
        return.
    end.
    else
        run prgint/edu/edu001ka.p /*prg_sea_parcei_edi*/.

    if  v_rec_parcei_edi <> ? then do:
        run prgint/edu/edu721za.py
                (input 1, 
                 input-output v_rec_parcei_edi, 
                 input-output i-parc , 
                 output       c-nome).
    
        if  i-parc <> 0 then 
            assign transporte.cdn-parcei-edi:screen-value in frame {&frame-name} = string(i-parc).
    
    end.
    */                   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME transporte.log-EDI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.log-EDI V-table-Win
ON VALUE-CHANGED OF transporte.log-EDI IN FRAME f-main /* Comunica Via EDI */
DO:
   if  mgadm.transporte.log-edi:checked in frame {&frame-name} then 
       enable mgadm.transporte.cdn-parcei-edi with frame {&frame-name}.
   else do:
       assign mgadm.transporte.cdn-parcei-edi:SCREEN-VALUE in frame {&frame-name} = "0".
       disable mgadm.transporte.cdn-parcei-edi with frame {&frame-name}.
   end.
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

/* Usu†rio do produto internacional ? */
ASSIGN l-internacional = i-pais-impto-usuario <> 1.

/* Remove campos exclusivos do produto internacional */
IF NOT l-internacional THEN DO WITH FRAME {&FRAME-NAME}:
  ASSIGN transporte.log-envia-dados:VISIBLE = NO.
END.

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
  {src/adm/template/row-list.i "transporte"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "transporte"}

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

    DEFINE VARIABLE c-cod-transp-ecommerce LIKE transporte.cod-transp-ecommerce NO-UNDO.
    DEFINE VARIABLE c-des-ident-transp     LIKE transporte.des-ident-transp     NO-UNDO.
    DEFINE VARIABLE l-log-edi              LIKE transporte.log-edi              NO-UNDO.
    DEFINE VARIABLE i-cdn-parcei-edi       LIKE transporte.cdn-parcei-EDI       NO-UNDO.

    ASSIGN c-cod-transp-ecommerce = transporte.cod-transp-ecommerce:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           c-des-ident-transp     = transporte.des-ident-transp:SCREEN-VALUE     IN FRAME {&FRAME-NAME}
           l-log-edi              = transporte.log-edi:CHECKED                   IN FRAME {&FRAME-NAME}
           i-cdn-parcei-edi       = INT(transporte.cdn-parcei-EDI:SCREEN-VALUE   IN FRAME {&FRAME-NAME}).

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    IF AVAIL transporte THEN DO:
       IF l-e-commerce AND adm-new-record THEN DO:
          IF transporte.cod-transp-ecommerce:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
             FIND FIRST bfTransporte WHERE bfTransporte.cod-transp-ecommerce = transporte.cod-transp-ecommerce:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.             
             IF AVAIL bfTransporte THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 55100,
                                   INPUT transporte.cod-transp-ecommerce + '~~' + STRING(bfTransporte.cod-transp)).
                APPLY 'entry' TO transporte.cod-transp-ecommerce IN FRAME {&FRAME-NAME}.
                RETURN "adm-error".                                  
             END.
          END.
       END.
    END.

    /* Dispatch standard ADM method.*/
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    ASSIGN transporte.cod-transp-ecommerce                                 = c-cod-transp-ecommerce
           transporte.des-ident-transp                                     = c-des-ident-transp
           transporte.log-edi                                              = l-log-edi         
           transporte.cdn-parcei-EDI                                       = i-cdn-parcei-edi
           transporte.des-ident-transp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-des-ident-transp 
           transporte.log-edi:CHECKED IN FRAME {&FRAME-NAME}               = l-log-edi.               
           transporte.cdn-parcei-EDI:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = STRING(i-cdn-parcei-edi).
    
    IF RETURN-VALUE = 'ADM-ERROR':U THEN 
       RETURN 'ADM-ERROR':U.

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
    
    /* Desabilita C¢digo Transportadora E-commerce */
    IF l-e-commerce THEN
       DISABLE transporte.cod-transp-ecommerce WITH FRAME {&frame-name}.
    
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

    if  mgadm.transporte.log-edi:checked in frame {&frame-name} then 
        enable mgadm.transporte.cdn-parcei-edi with frame {&frame-name}.
    else
        disable mgadm.transporte.cdn-parcei-edi with frame {&frame-name}.
   
    /* habilita c¢digo transportadora e-commerce */
    IF l-e-commerce THEN
       ENABLE transporte.cod-transp-ecommerce WITH FRAME {&frame-name}.
       
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    find first param-global no-lock. 
    
    if  transporte.log-edi:checked in frame {&frame-name} and
        param-global.modulo-ed = YES and 
        int(transporte.cdn-parcei-edi:screen-value in frame {&frame-name}) = 0 then do:
        {include/i-vldprg.i}
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Parceiro_EDI" *}
        run utp/ut-msgs.p (input "show",
                           input 265,
                           input RETURN-VALUE).
        apply 'entry' to transporte.cdn-parcei-edi in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    /* 
    if  int(transporte.cdn-parcei-edi:screen-value in frame {&frame-name}) <> 0 and 
        param-global.modulo-ed = YES and 
        connected("emsedi") then do:
        
        assign i-parc = int(transporte.cdn-parcei-edi:screen-value in frame {&frame-name})
               c-nome = "".

        run prgint/edu/edu721za.py
                (input 1, 
                 input-output r-param, 
                 input-output i-parc , 
                 output       c-nome).

        if  c-nome = "" and i-parc = 0 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 15839,
                               input "Parceiro EDI" + "~~" + "M¢dulo EDI").
            apply 'entry' to transporte.cdn-parcei-edi in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        
    end.

     */
    if  transporte.des-ident-transp:screen-value in frame {&frame-name} = "" and
        param-global.modulo-tf = yes then do:
        {include/i-vldprg.i}
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Identificaá∆o_da_Transportadora" *}
        run utp/ut-msgs.p (input "show",
                           input 265,
                           input RETURN-VALUE).
        apply 'entry' to transporte.des-ident-transp in frame {&frame-name}.
        return 'ADM-ERROR':U.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* habilita somente se o E-commerce estiver ativado no cd0101 */
  
  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF AVAIL param-global AND SUBSTRING(param-global.char-2,47,1) = "S" THEN                         
     ASSIGN l-e-commerce = YES.
  ELSE
     ASSIGN transporte.cod-transp-ecommerce:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
            l-e-commerce = NO.
         
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

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "nome-abrev" "transporte" "nome-abrev"}
  {src/adm/template/sndkycas.i "cod-transp" "transporte" "cod-transp"}
  {src/adm/template/sndkycas.i "cod-emitente" "transporte" "cod-emitente"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "transporte"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  DO WITH FRAME {&frame-name} on error undo, return "adm-error":
      
     ASSIGN {&adm-create-fields} {&adm-modify-fields}.
    
     IF ERROR-STATUS:ERROR THEN 
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        
  END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



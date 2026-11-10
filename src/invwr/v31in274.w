&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V31IN274 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v31in274 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ordem-compra
&Scoped-define FIRST-EXTERNAL-TABLE ordem-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ordem-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ordem-compra.estab-entrega ordem-compra.int-2 ~
ordem-compra.cod-entrega ordem-compra.nr-pedcli ordem-compra.seq-ped-venda 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}estab-entrega ~{&FP2}estab-entrega ~{&FP3}~
 ~{&FP1}int-2 ~{&FP2}int-2 ~{&FP3}~
 ~{&FP1}cod-entrega ~{&FP2}cod-entrega ~{&FP3}~
 ~{&FP1}nr-pedcli ~{&FP2}nr-pedcli ~{&FP3}~
 ~{&FP1}seq-ped-venda ~{&FP2}seq-ped-venda ~{&FP3}
&Scoped-define ENABLED-TABLES ordem-compra
&Scoped-define FIRST-ENABLED-TABLE ordem-compra
&Scoped-Define ENABLED-OBJECTS rt-key RECT-12 c-end-completo 
&Scoped-Define DISPLAYED-FIELDS ordem-compra.estab-entrega ~
ordem-compra.int-2 ordem-compra.cod-entrega ordem-compra.nr-pedcli ~
ordem-compra.seq-ped-venda 
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab-entrega c-emit-entrega ~
c-endereco_text c-endereco c-cep c-bairro c-cidade c-estado c-pais ~
c-jurisdicao c-end-completo 

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
DEFINE VARIABLE c-endereco_text AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 38 BY 2.5.

DEFINE VARIABLE c-bairro AS CHARACTER FORMAT "x(30)" 
     LABEL "Bairro" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-cep AS CHARACTER FORMAT "x(12)" 
     LABEL "CEP" 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .88.

DEFINE VARIABLE c-cidade AS CHARACTER FORMAT "x(25)" 
     LABEL "Cidade" 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .88.

DEFINE VARIABLE c-desc-estab-entrega AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-emit-entrega AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE c-end-completo AS CHARACTER FORMAT "X(256)":U INITIAL "End Completo:" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-endereco AS CHARACTER FORMAT "x(40)" 
     LABEL "Endere‡o" 
     VIEW-AS FILL-IN 
     SIZE 46.14 BY .88.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "x(4)" 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE c-jurisdicao AS CHARACTER FORMAT "x(20)" 
     LABEL "Jurisdi‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .88.

DEFINE VARIABLE c-pais AS CHARACTER FORMAT "x(20)" 
     LABEL "Pa¡s" 
     VIEW-AS FILL-IN 
     SIZE 18.86 BY .88.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.29 BY 2.75.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.14 BY 9.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ordem-compra.estab-entrega AT ROW 1.21 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-estab-entrega AT ROW 1.21 COL 25.43 COLON-ALIGNED NO-LABEL
     ordem-compra.int-2 AT ROW 2.21 COL 16 COLON-ALIGNED
          LABEL "Emitente Entrega"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     c-emit-entrega AT ROW 2.21 COL 28.14 COLON-ALIGNED NO-LABEL
     ordem-compra.cod-entrega AT ROW 3.21 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ordem-compra.nr-pedcli AT ROW 3.21 COL 45 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     ordem-compra.seq-ped-venda AT ROW 3.21 COL 76.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-endereco_text AT ROW 4.33 COL 35.57 NO-LABEL
     c-endereco AT ROW 7 COL 16 COLON-ALIGNED
     c-cep AT ROW 7 COL 69 COLON-ALIGNED
     c-bairro AT ROW 8 COL 16 COLON-ALIGNED
     c-cidade AT ROW 8 COL 57.14 COLON-ALIGNED
     c-estado AT ROW 9 COL 16 COLON-ALIGNED
     c-pais AT ROW 9 COL 28 COLON-ALIGNED
     c-jurisdicao AT ROW 9 COL 57.14 COLON-ALIGNED
     c-end-completo AT ROW 4.38 COL 19.14 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-12 AT ROW 4.17 COL 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ordem-compra
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
         WIDTH              = 86.14.
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

/* SETTINGS FOR FILL-IN c-bairro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cep IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab-entrega IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-emit-entrega IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-endereco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR c-endereco_text IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-jurisdicao IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-jurisdicao:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-pais IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.int-2 IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME c-jurisdicao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-jurisdicao V-table-Win
ON F5 OF c-jurisdicao IN FRAME f-main /* Jurisdi‡Æo */
DO:
/*    /* Zoom Smart Object */
 *     {include/zoomvar.i &prog-zoom="dizoom/z01di350.w"
 *                        &campo=tt-pedido-compr.jurisdicao
 *                        &campozoom=cd-jurisdicao}   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-jurisdicao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-jurisdicao IN FRAME f-main /* Jurisdi‡Æo */
DO:
  apply "f5":U to self.
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

  {utp/ut-liter.i End_Completo: * l }
  assign c-end-completo = trim(return-value).
  disp c-end-completo with frame {&frame-name}.

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
  {src/adm/template/row-list.i "ordem-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ordem-compra"}

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
  
  for first estabelec fields(nome)
      where estabelec.cod-estabel = ordem-compra.estab-entrega no-lock: end.
  if  avail estabelec then
      assign c-desc-estab-entrega = estabelec.nome.
  else
     assign c-desc-estab-entrega = "".
 
  disp c-desc-estab-entrega with frame {&frame-name}.
    
  if  ordem-compra.local-entrega = 1 /* Estabelecimento */ then do:
      if  ordem-compra.estab-entrega <> "":U then do:
          for first estabelec fields(endereco bairro
                                     cidade estado pais cep ) 
              where estabelec.cod-estabel = ordem-compra.estab-entrega no-lock:
                 
                       assign c-endereco = estabelec.endereco
                              c-bairro   = estabelec.bairro
                              c-cidade   = estabelec.cidade
                              c-estado   = estabelec.estado
                              c-pais     = estabelec.pais
                              c-cep      = string(estabelec.cep)
                              c-endereco_text = "":U
                              c-jurisdicao    = "":U
                              c-emit-entrega  = "":U.
                
                       disp c-endereco
                            c-bairro
                            c-cidade
                            c-estado
                            c-pais
                            c-endereco_text
                            c-jurisdicao 
                            c-cep
                            c-emit-entrega with frame {&frame-name}.
          end.
                   
          if  not avail estabelec then do:
              assign c-endereco = "":U
                     c-bairro   = "":U
                     c-cidade   = "":U
                     c-estado   = "":U
                     c-pais     = "":U
                     c-endereco_text = "":U
                     c-jurisdicao    = "":U
                     c-emit-entrega  = "":U
                     c-cep           = "":U.
         
              disp c-endereco
                   c-bairro
                   c-cidade
                   c-estado
                   c-pais
                   c-endereco_text
                   c-jurisdicao 
                   c-cep
                   c-emit-entrega with frame {&frame-name}.       
          end.
      end. 
      else do:
          assign c-emit-entrega = "":U
                 c-endereco = "":U
                 c-bairro   = "":U
                 c-cidade   = "":U
                 c-estado   = "":U
                 c-pais     = "":U
                 c-endereco_text = "":U
                 c-cep           = "":U
                 c-jurisdicao    = "":U.
   
          disp c-emit-entrega 
               c-endereco
               c-bairro
               c-cidade
               c-estado
               c-pais
               c-endereco_text
               c-cep
               c-jurisdicao with frame {&frame-name}.
        
      end.
  end.
  else if ordem-compra.local-entrega = 2 /* Emitente */ then do:
      if  ordem-compra.nr-pedcli <> "":U
      and ordem-compra.nr-pedcli <> "0":U then do:
          for first emitente fields(nome-abrev)
              where emitente.cod-emitente = ordem-compra.int-2 no-lock,
          first ped-item fields(cod-entrega)
              where ped-item.nr-pedcli    = ordem-compra.nr-pedcli
                and ped-item.nr-sequencia = ordem-compra.seq-ped-venda 
                and ped-item.nome-abrev   = emitente.nome-abrev no-lock:
                
                  run pi-display-campos-loc-entr(input emitente.nome-abrev,
                                                 input ped-item.cod-entrega).
                            
                  assign c-emit-entrega  = emitente.nome-abrev.
                
                  disp c-emit-entrega with frame {&frame-name}.
          end.   
      end.
      else if  ordem-compra.cod-entrega <> "":U 
          and ordem-compra.cod-entrega <> "0":U then do:
          for first emitente fields(nome-abrev)
              where emitente.cod-emitente = ordem-compra.int-2 no-lock:
                 
              run pi-display-campos-loc-entr(input emitente.nome-abrev,
                                             input ordem-compra.cod-entrega).
                                                    
              assign c-emit-entrega  = emitente.nome-abrev.
      
              disp c-emit-entrega with frame {&frame-name}.
          end.
      end.
      else do:           
      
          /*--- Quando for optado por endereco esporadico na Ordem Compra
                ser  mostrado o endereco cadastrado no pedido de compra ----*/
          if  (   ordem-compra.cod-entrega = "0" 
               or ordem-compra.cod-entrega = "")
          and (   ordem-compra.nr-pedcli = "0" 
               or ordem-compra.nr-pedcli = "") 
          and ordem-compra.num-pedido > 0 then do:
              
              find pedido-compr where
                   pedido-compr.num-pedido = ordem-compra.num-pedido no-lock no-error.
              if  avail pedido-compr
              and pedido-compr.local-entrega = 2 then 
                  assign c-endereco_text = pedido-compr.endereco_text
                         c-endereco      = pedido-compr.endereco
                         c-bairro        = pedido-compr.bairro
                         c-cidade        = pedido-compr.cidade
                         c-estado        = pedido-compr.estado
                         c-pais          = pedido-compr.pais
                         c-cep           = pedido-compr.cep
                         c-jurisdicao    = pedido-compr.jurisdicao. 
          end.     
          else
              assign c-emit-entrega = "":U
                     c-endereco = "":U
                     c-bairro   = "":U
                     c-cidade   = "":U
                     c-estado   = "":U
                     c-pais     = "":U
                     c-endereco_text = "":U
                     c-jurisdicao    = "":U
                     c-cep           = "":U.
           
          disp c-endereco
               c-bairro
               c-cidade
               c-estado
               c-pais
               c-endereco_text
               c-jurisdicao 
               c-emit-entrega 
               c-cep with frame {&frame-name}.       
      end. 
   end. 
  else do:
      assign c-emit-entrega = "":U
             c-endereco = "":U
             c-bairro   = "":U
             c-cidade   = "":U
             c-estado   = "":U
             c-pais     = "":U
             c-endereco_text = "":U
             c-jurisdicao    = "":U
             c-cep           = "":U.
  
      disp c-emit-entrega 
           c-endereco
           c-bairro
           c-cidade
           c-estado
           c-pais
           c-endereco_text
           c-cep
           c-jurisdicao with frame {&frame-name}.
  end.

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /*--- Campo jurisdicao e usado somente nos EUA ---*/
  if  i-pais-impto-usuario = 3 then
      assign c-jurisdicao:visible in frame {&frame-name} = yes.
  else
      assign c-jurisdicao:visible in frame {&frame-name} = no.

  find first param-global no-lock no-error.
  
  if  avail param-global then
      assign c-cep:format in frame {&frame-name} = param-global.formato-cep.
      
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display-campos-loc-entr V-table-Win 
PROCEDURE pi-display-campos-loc-entr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-nome-abrev  like emitente.nome-abrev  no-undo.
    def input param pc-cod-entrega like loc-entr.cod-entrega no-undo.
    
    for first loc-entr fields (endereco_text endereco
                               bairro cidade cep estado
                               pais cd-jurisdicao)
        where loc-entr.nome-abrev = pc-nome-abrev
          and loc-entr.cod-entrega = pc-cod-entrega no-lock:
        
        assign c-endereco_text = loc-entr.endereco_text
               c-endereco      = loc-entr.endereco
               c-bairro        = loc-entr.bairro
               c-cidade        = loc-entr.cidade
               c-cep           = loc-entr.cep
               c-estado        = loc-entr.estado
               c-pais          = loc-entr.pais
               c-jurisdicao    = loc-entr.cd-jurisdicao.
          
    end. 

    if  not avail loc-entr then
        assign c-endereco_text = ""
               c-endereco      = ""
               c-bairro        = ""
               c-cidade        = ""
               c-cep           = ""
               c-estado        = ""
               c-pais          = ""
               c-jurisdicao    = "".
               
    disp c-endereco_text 
         c-endereco      
         c-bairro        
         c-cidade        
         c-cep           
         c-estado        
         c-pais          
         c-jurisdicao with frame {&frame-name}.

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
  {src/adm/template/snd-list.i "ordem-compra"}

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



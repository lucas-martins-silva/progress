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
{include/i-prgvrs.i V01IN255 2.00.00.026}  /*** 010026 ***/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN255 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                
DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.

def var rw-parent as rowid no-undo.

{cdp/cdcfgman.i}
{cdp/cdcfgmnt.i}

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
&Scoped-define EXTERNAL-TABLES op-ferram
&Scoped-define FIRST-EXTERNAL-TABLE op-ferram


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-ferram.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS op-ferram.proporcao op-ferram.un-ciclo ~
op-ferram.observacao 
&Scoped-define ENABLED-TABLES op-ferram
&Scoped-define FIRST-ENABLED-TABLE op-ferram
&Scoped-Define ENABLED-OBJECTS fi-sequencia de-tempo-espera de-ajuste-exec ~
de-lote-maximo de-lote-ideal rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS operacao.op-codigo operacao.descricao ~
op-ferram.proporcao op-ferram.un-ciclo op-ferram.observacao 
&Scoped-define DISPLAYED-TABLES operacao op-ferram
&Scoped-define FIRST-DISPLAYED-TABLE operacao
&Scoped-define SECOND-DISPLAYED-TABLE op-ferram
&Scoped-Define DISPLAYED-OBJECTS c-codigo c-descricao fi_ferramenta ~
c-tp-ferr-descricao fi-sequencia de-tempo-espera de-ajuste-exec ~
de-lote-maximo de-lote-ideal 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi_ferramenta 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-ferramental 
       MENU-ITEM m_Ferramenta   LABEL "Ferramenta"    
       MENU-ITEM m_Equipamento  LABEL "Equipamento"   .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-ferr-descricao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-ajuste-exec AS DECIMAL FORMAT "999.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-lote-ideal AS DECIMAL FORMAT ">>>>>>>>>>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE de-lote-maximo AS DECIMAL FORMAT ">>>>>>>>>>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE de-tempo-espera AS DECIMAL FORMAT "999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi_ferramenta AS CHARACTER FORMAT "x(16)" 
     LABEL "Ferram/Equipto":R14 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-codigo AT ROW 1.17 COL 21 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-descricao AT ROW 1.17 COL 35.57 COLON-ALIGNED NO-LABEL
     operacao.op-codigo AT ROW 2.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     operacao.descricao AT ROW 2.17 COL 28.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.29 BY .88
     fi_ferramenta AT ROW 3.25 COL 21 COLON-ALIGNED
     c-tp-ferr-descricao AT ROW 3.25 COL 34 COLON-ALIGNED NO-LABEL
     op-ferram.proporcao AT ROW 4.67 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     op-ferram.un-ciclo AT ROW 5.67 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     fi-sequencia AT ROW 6.67 COL 16 COLON-ALIGNED
     op-ferram.observacao AT ROW 7.67 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     de-tempo-espera AT ROW 4.67 COL 70 COLON-ALIGNED
     de-ajuste-exec AT ROW 5.67 COL 70 COLON-ALIGNED
     de-lote-maximo AT ROW 6.67 COL 70 COLON-ALIGNED
     de-lote-ideal AT ROW 7.67 COL 70 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.op-ferram
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
         HEIGHT             = 7.92
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
       FRAME f-main:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-ferr-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_ferramenta IN FRAME f-main
   NO-ENABLE 1                                                          */
ASSIGN 
       fi_ferramenta:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-ferramental:HANDLE.

/* SETTINGS FOR FILL-IN operacao.op-codigo IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fi_ferramenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_ferramenta V-table-Win
ON F5 OF fi_ferramenta IN FRAME f-main /* Ferram/Equipto */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z02in465.w"
                      &campo=fi_ferramenta
                      &campozoom=cod-ferr-prod
                      &campo2=c-tp-ferr-descricao
                      &campozoom2=des-ferr-prod}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_ferramenta V-table-Win
ON LEAVE OF fi_ferramenta IN FRAME f-main /* Ferram/Equipto */
DO:
    FIND FIRST ferr-prod WHERE ferr-prod.cod-ferr-prod = input frame {&frame-name} fi_ferramenta NO-LOCK NO-ERROR.
    IF AVAIL ferr-prod THEN DO:
        {include/leave.i &tabela=ferr-prod
                     &atributo-ref=des-ferr-prod
                     &variavel-ref=c-tp-ferr-descricao
                     &where="ferr-prod.cod-ferr-prod = input frame {&frame-name} fi_ferramenta"}
        &if defined (bf_man_sfc_lc) &then
        if  avail ferr-prod then do:
            if  ferr-prod.un-ciclo <> 0 then
                assign op-ferram.un-ciclo:screen-value in frame {&frame-name} = string(ferr-prod.un-ciclo)
                       op-ferram.un-ciclo:sensitive in frame {&frame-name}    = no.
            else
                assign op-ferram.un-ciclo:screen-value in frame {&frame-name} = string(ferr-prod.un-ciclo)
                       op-ferram.un-ciclo:sensitive in frame {&frame-name} = yes.
        end.
        &endif.

    END.
    ELSE DO:
        FIND FIRST equipto WHERE 
                   equipto.cd-equipto = fi_ferramenta:screen-value in frame {&frame-name} NO-LOCK NO-ERROR.
        if avail equipto THEN DO:
              {include/leave.i &tabela=equipto
                      &atributo-ref=descricao
                      &variavel-ref=c-tp-ferr-descricao
                      &where="equipto.cd-equipto = fi_ferramenta:screen-value in frame {&frame-name}"}
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_ferramenta V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi_ferramenta IN FRAME f-main /* Ferram/Equipto */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Equipamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Equipamento V-table-Win
ON CHOOSE OF MENU-ITEM m_Equipamento /* Equipamento */
DO:
  assign l-implanta = yes.
  &IF DEFINED (bf_man_203) &THEN

   {method/zoomfields.i 
           &ProgramZoom="mnzoom/z02mn088.w"
           &FieldZoom1="cd-equipto"
           &FieldScreen1="fi_ferramenta"
           &Frame1="{&frame-name}"
           &FieldZoom2="descricao"
           &FieldScreen2="c-tp-ferr-descricao"
           &Frame2="{&frame-name}"}
           
   &else
    {include/zoomvar.i &prog-zoom=inzoom/z01in095.w
                       &campo=fi_ferramenta
                       &campozoom=cd-equipto
                       &campo2=c-tp-ferr-descricao
                       &campozoom2=descricao}
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ferramenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ferramenta V-table-Win
ON CHOOSE OF MENU-ITEM m_Ferramenta /* Ferramenta */
DO:
   apply "F5" to fi_ferramenta  in frame {&frame-name}.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  If fi_ferramenta:load-mouse-pointer ("image/rbm.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "op-ferram"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "op-ferram"}

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

  /* Code placed here will execute AFTER standard behavior.    */
  display c-codigo c-descricao with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    def var c-sequencia    as char no-undo.
    def var de-tempo-esp as dec format "999" no-undo.
    def var de-lote-max  as dec format "999999999999.99" no-undo.
    def var de-lote-ide   as dec format "999999999999.99" no-undo.
    def var de-ajuste-ex  as dec format "999.99" no-undo.


  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  find operacao where rowid(operacao) = rw-parent NO-LOCK no-error.

  if fi_ferramenta:sensitive in frame {&frame-name} = yes 
  and can-find (op-ferram 
      where op-ferram.num-id-operacao = operacao.num-id-operacao 
      and   op-ferram.op-altern       = 0              
      and   op-ferram.ferramenta      = input frame {&frame-name} fi_ferramenta) then do:
     {utp/ut-table.i mgind op-ferram 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).

     apply "entry" to fi_ferramenta in frame {&frame-name}.
     return 'ADM-ERROR':U.                       
  end.

  if fi_ferramenta:sensitive in frame {&frame-name} = yes THEN DO:

     IF NOT CAN-FIND(FIRST ferr-prod WHERE 
                           ferr-prod.cod-ferr-prod = fi_ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock) THEN DO:
        run utp/ut-msgs.p (input "show",
                           input 28022,
                           input "").
        IF RETURN-VALUE = "yes" THEN DO:
           IF NOT CAN-FIND(FIRST equipto WHERE 
                                 equipto.cd-equipto = fi_ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock) THEN DO:
               {utp/ut-liter.i "Equipamento"}
               run utp/ut-msgs.p (input "show",
                                 input 56,
                                 input RETURN-VALUE).
               apply "entry" to fi_ferramenta in frame {&frame-name}.
               return 'ADM-ERROR':U.                       
           END.
        END.
        ELSE DO:
           apply "entry" to fi_ferramenta in frame {&frame-name}.
           return 'ADM-ERROR':U.                       
        END.
     END.
  END.

       assign c-sequencia    = string(input frame {&frame-name} fi-sequencia)
         de-tempo-esp = input frame {&frame-name} de-tempo-espera
         de-lote-max  = input frame {&frame-name} de-lote-maximo
         de-lote-ide   = input frame {&frame-name} de-lote-ideal
         de-ajuste-ex  = input frame {&frame-name} de-ajuste-exec.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

    assign substring(op-ferram.char-1,1,3) = string(c-sequencia,"999")
           op-ferram.ferramenta      = fi_ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           op-ferram.op-altern       = 0
           op-ferram.num-id-operacao = operacao.num-id-operacao.


    &IF DEFINED (bf_man_sfc_lc) &THEN
        assign substr(op-ferram.char-1,4,3)   = string(de-tempo-esp,"999")
               substr(op-ferram.char-1,7,15)  = string(de-lote-max,"999999999999.99")
               substr(op-ferram.char-1,22,15) = string(de-lote-ide,"999999999999.99")
               substr(op-ferram.char-1,37,6)  = string(de-ajuste-ex,"999.99").    
    &ENDIF  

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail operacao then 
     assign op-ferram.num-id-operacao = operacao.num-id-operacao.

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
    if  avail op-ferram then do:

    /*** FO de n§ 1086.980 ***/
        if ADM-NEW-RECORD then
           find ferr-prod where ferr-prod.cod-ferr-prod = fi_ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock no-error.
        else
           find ferr-prod where ferr-prod.cod-ferr-prod = op-ferram.ferramenta no-lock no-error.
        IF AVAIL ferr-prod THEN DO:
           assign fi_ferramenta       = if avail ferr-prod then ferr-prod.cod-ferr-prod else "":U.
                  c-tp-ferr-descricao = if avail ferr-prod then ferr-prod.des-ferr-prod else "":U.
                  fi-sequencia        = int(substring(op-ferram.char-1,1,3)).     
              &IF DEFINED (bf_man_sfc_lc) &THEN
                if  avail param-global 
                and param-global.modulo-sws then
                    assign de-tempo-espera = int(substring(op-ferram.char-1,4,3))
                           de-lote-maximo  = dec(substring(op-ferram.char-1,7,15))
                           de-lote-ideal   = dec(substring(op-ferram.char-1,22,15))
                           de-ajuste-exec  = dec(substring(op-ferram.char-1,37,6)).
              &ENDIF
        END.
        ELSE DO:  
           FIND FIRST equipto 
                WHERE equipto.cd-equipto = op-ferram.ferramenta NO-LOCK NO-ERROR.
           IF AVAIL equipto THEN
              assign fi_ferramenta       = IF AVAIL equipto THEN equipto.cd-equipto ELSE "":U.
                     c-tp-ferr-descricao = if avail equipto then equipto.descricao else "":U.
        END.
              
    END.
    /*ELSE DO:  
       FIND FIRST equipto WHERE 
                  equipto.cd-equipto = fi_ferramenta:screen-value in frame {&frame-name} no-lock no-error.
       assign c-tp-ferr-descricao = if avail equipto then equipto.descricao else "":U.

    END.*/



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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &if defined (bf_man_sfc_lc) &then

      if  avail op-ferram
      and avail ferr-prod then do:
          if  ferr-prod.un-ciclo <> 0 then
              assign op-ferram.un-ciclo:sensitive in frame {&frame-name} = no.
      end.
  &endif.

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

  find operacao where rowid(operacao) = v-row-parent no-lock no-error.
  if not avail operacao then do:
    {utp/ut-table.i mgind operacao 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    return "adm-error":U.
  end.      

  assign rw-parent = v-row-parent.

  if operacao.cod-roteiro <> '' then do:
     {utp/ut-field.i mgind rot-fabric cod-roteiro 1}
     find rot-fabric where rot-fabric.cod-roteiro = operacao.cod-roteiro no-lock no-error.
     assign c-codigo    = operacao.cod-roteiro
            c-descricao = if avail rot-fabric then rot-fabric.descricao else "":U
            c-codigo:label in frame {&frame-name} = return-value.
  end.
  else do:
     {utp/ut-field.i mgind operacao it-codigo 1}
     find item where item.it-codigo = operacao.it-codigo no-lock no-error.
     assign c-codigo    = operacao.it-codigo
            c-descricao = if avail item then item.desc-item else "":U
            c-codigo:label in frame {&frame-name} = return-value.
  end. 

  {utp/ut-liter.i Sequˆncia     * R} assign fi-sequencia:label    in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Lote_Execu‡Æo * R} assign de-ajuste-exec:label  in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Tempo_Espera  * R} assign de-tempo-espera:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Lote_M ximo   * R} assign de-lote-maximo:label  in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Lote_Ideal    * R} assign de-lote-ideal:label   in frame {&frame-name} = trim(return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    &IF DEFINED (bf_man_sfc_lc) &THEN 
        find first param-global no-lock no-error.
        if  param-global.modulo-sws then
            assign de-ajuste-exec:hidden  in frame {&frame-name} = no
                   de-tempo-espera:hidden in frame {&frame-name} = no
                   de-lote-maximo:hidden  in frame {&frame-name} = no
                   de-lote-ideal:hidden   in frame {&frame-name} = no.
        else
            assign de-ajuste-exec:hidden  in frame {&frame-name} = yes
                   de-tempo-espera:hidden in frame {&frame-name} = yes
                   de-lote-maximo:hidden  in frame {&frame-name} = yes
                   de-lote-ideal:hidden   in frame {&frame-name} = yes.
    &ELSE
        assign de-ajuste-exec:hidden  in frame {&frame-name} = yes
               de-tempo-espera:hidden in frame {&frame-name} = yes
               de-lote-maximo:hidden  in frame {&frame-name} = yes
               de-lote-ideal:hidden   in frame {&frame-name} = yes.
    &ENDIF


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
  {src/adm/template/snd-list.i "op-ferram"}

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


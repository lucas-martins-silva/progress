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
{include/i-prgvrs.i V02IN255 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN255 MUT}
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

def buffer b-op-ferram for op-ferram.

def var rw-parent as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES op-ferram
&Scoped-define FIRST-EXTERNAL-TABLE op-ferram


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-ferram.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS op-ferram.proporcao op-ferram.un-ciclo ~
op-ferram.observacao 
&Scoped-define ENABLED-TABLES op-ferram
&Scoped-define FIRST-ENABLED-TABLE op-ferram
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS operacao.op-codigo operacao.descricao ~
op-altern.op-altern op-altern.descricao op-ferram.ferramenta ~
op-ferram.proporcao op-ferram.un-ciclo op-ferram.observacao 
&Scoped-define DISPLAYED-TABLES operacao op-altern op-ferram
&Scoped-define FIRST-DISPLAYED-TABLE operacao
&Scoped-define SECOND-DISPLAYED-TABLE op-altern
&Scoped-define THIRD-DISPLAYED-TABLE op-ferram
&Scoped-Define DISPLAYED-OBJECTS c-codigo c-descricao c-tp-ferr-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS op-ferram.ferramenta 

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
DEFINE MENU POPUP-MENU-ferramenta 
       MENU-ITEM m_Ferramenta   LABEL "Ferramenta"    
       MENU-ITEM m_Equipamento  LABEL "Equipamento"   .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-ferr-descricao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-codigo AT ROW 1.17 COL 25 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-descricao AT ROW 1.17 COL 42.43 COLON-ALIGNED NO-LABEL
     operacao.op-codigo AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     operacao.descricao AT ROW 2.17 COL 32.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36 BY .88
     op-altern.op-altern AT ROW 3.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     op-altern.descricao AT ROW 3.17 COL 32.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36 BY .88
     op-ferram.ferramenta AT ROW 4.17 COL 25 COLON-ALIGNED
          LABEL "Ferram/Eqpto":R12
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-tp-ferr-descricao AT ROW 4.17 COL 37.86 COLON-ALIGNED NO-LABEL
     op-ferram.proporcao AT ROW 5.58 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     op-ferram.un-ciclo AT ROW 6.58 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     op-ferram.observacao AT ROW 7.58 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
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
         HEIGHT             = 7.67
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-ferr-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN op-altern.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN op-ferram.ferramenta IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
ASSIGN 
       op-ferram.ferramenta:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-ferramenta:HANDLE.

/* SETTINGS FOR FILL-IN op-altern.op-altern IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME op-ferram.ferramenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-ferram.ferramenta V-table-Win
ON F5 OF op-ferram.ferramenta IN FRAME f-main /* Ferram/Eqpto */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z02in465.w"
                      &campo=op-ferram.ferramenta
                      &campozoom=cod-ferr-prod
                      &campo2=c-tp-ferr-descricao
                      &campozoom2=des-ferr-prod}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-ferram.ferramenta V-table-Win
ON LEAVE OF op-ferram.ferramenta IN FRAME f-main /* Ferram/Eqpto */
DO:
    
    FIND FIRST ferr-prod WHERE ferr-prod.cod-ferr-prod = input frame f-main op-ferram.ferramenta NO-LOCK NO-ERROR.
    IF AVAIL ferr-prod THEN DO:

        {include/leave.i &tabela=ferr-prod
                     &atributo-ref=des-ferr-prod
                     &variavel-ref=c-tp-ferr-descricao
                     &where="ferr-prod.cod-ferr-prod = input frame f-main op-ferram.ferramenta"}
                     

        &if defined (bf_man_sfc_lc) &then
        if  avail ferr-prod then do:
            if  ferr-prod.un-ciclo <> 0 then
                assign op-ferram.un-ciclo:screen-value in frame f-main = string(ferr-prod.un-ciclo)
                       op-ferram.un-ciclo:sensitive in frame f-main    = no.
            else
                assign op-ferram.un-ciclo:screen-value in frame f-main = string(ferr-prod.un-ciclo)
                       op-ferram.un-ciclo:sensitive in frame f-main = yes.
        end.
        &endif.

    END.
    ELSE DO:
       FIND FIRST equipto WHERE 
                  equipto.cd-equipto = op-ferram.ferramenta:screen-value in frame f-main NO-LOCK NO-ERROR.
       
       if avail equipto THEN       DO:
              {include/leave.i &tabela=equipto
                     &atributo-ref=descricao
                     &variavel-ref=c-tp-ferr-descricao
                     &where="equipto.cd-equipto = op-ferram.ferramenta:screen-value in frame {&frame-name}"}
       END.
           
           /*assign c-tp-ferr-descricao:SCREEN-VALUE IN frame {&frame-name} =  equipto.descricao.
       END.
       ELSE 
           ASSIGN c-tp-ferr-descricao:SCREEN-VALUE IN frame {&frame-name} = "".
             */
    END.   


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-ferram.ferramenta V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-ferram.ferramenta IN FRAME f-main /* Ferram/Eqpto */
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
  &IF defined (bf_man_203) &THEN
   {method/zoomfields.i 
           &ProgramZoom="mnzoom/z02mn088.w"
           &FieldZoom1="cd-equipto"
           &FieldScreen1="op-ferram.ferramenta"
           &Frame1="f-main"
           &FieldZoom2="descricao"
           &FieldScreen2="c-tp-ferr-descricao"
           &Frame2="f-main"}
  &else
  {include/zoomvar.i &prog-zoom=inzoom/z01in095.w
                       &campo=op-ferram.ferramenta
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
  assign l-implanta = yes.

   {include/zoomvar.i &prog-zoom="inzoom/z02in465.w"
                      &campo=op-ferram.ferramenta
                      &campozoom=cod-ferr-prod
                      &campo2=c-tp-ferr-descricao
                      &campozoom2=des-ferr-prod}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  If op-ferram.ferramenta:load-mouse-pointer ("image/rbm.cur") in frame {&frame-name} then.
 
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

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  find op-altern where rowid(op-altern) = v-row-parent no-lock no-error.
  if op-ferram.ferramenta:sensitive in frame {&frame-name} = yes 
  and can-find (b-op-ferram 
      where b-op-ferram.num-id-operacao = op-altern.num-id-operacao 
      and   b-op-ferram.op-altern       = op-altern.op-altern
      and   b-op-ferram.ferramenta      = input frame {&frame-name} op-ferram.ferramenta) then do:
     {utp/ut-table.i mgind op-ferram 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).
     apply "entry" to op-ferram.ferramenta in frame {&frame-name}.
     return 'ADM-ERROR':U.                       
  end.

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

 if op-ferram.ferramenta:sensitive in frame {&frame-name} = yes THEN DO:

      IF NOT CAN-FIND(FIRST ferr-prod WHERE 
                            ferr-prod.cod-ferr-prod = op-ferram.ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock) THEN DO:
         run utp/ut-msgs.p (input "show",
                            input 28022,
                            input "").
         IF RETURN-VALUE = "yes" THEN DO:
            IF NOT CAN-FIND(FIRST equipto WHERE 
                                  equipto.cd-equipto = op-ferram.ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock) THEN DO:
                {utp/ut-liter.i Equipamento *}
                run utp/ut-msgs.p (input "show",
                                  input 56,
                                  input RETURN-VALUE).
                apply "entry" to op-ferram.ferramenta in frame {&frame-name}.
                return 'ADM-ERROR':U.                       
            END.
         END.
         ELSE DO:
            apply "entry" to op-ferram.ferramenta in frame {&frame-name}.
            return 'ADM-ERROR':U.                       
         END.
      END.

 END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.



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
  if avail op-altern then 
     assign op-ferram.num-id-operacao = op-altern.num-id-operacao
            op-ferram.op-altern       = op-altern.op-altern.

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
    /*
   if avail op-ferram then do:
     find ferr-prod where ferr-prod.cod-ferr-prod = op-ferram.ferramenta no-lock no-error.
     assign c-tp-ferr-descricao = if avail ferr-prod then ferr-prod.des-ferr-prod else "":U.
  end.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  */

 if  avail op-ferram then do:

    /*** FO de n§ 1086.980 ***/
        if ADM-NEW-RECORD then
           find ferr-prod where ferr-prod.cod-ferr-prod = op-ferram.ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK no-error.
        else
           find ferr-prod where ferr-prod.cod-ferr-prod = op-ferram.ferramenta NO-LOCK no-error.
        IF AVAIL ferr-prod THEN DO:
           assign op-ferram.ferramenta:SCREEN-VALUE IN FRAME {&FRAME-NAME}       = if avail ferr-prod then ferr-prod.cod-ferr-prod else "":U
                  c-tp-ferr-descricao = if avail ferr-prod then ferr-prod.des-ferr-prod else "":U.
                  /*fi-sequencia        = int(substring(op-ferram.char-1,1,3))*/.     
              /*&IF DEFINED (bf_man_sfc_lc) &THEN
                if  avail param-global 
                and param-global.modulo-sws then
                    assign de-tempo-espera = int(substring(op-ferram.char-1,4,3))
                           de-lote-maximo  = dec(substring(op-ferram.char-1,7,15))
                           de-lote-ideal   = dec(substring(op-ferram.char-1,22,15))
                           de-ajuste-exec  = dec(substring(op-ferram.char-1,37,6)).
              &ENDIF*/
        END.
        ELSE DO:  
    
           FIND FIRST equipto WHERE 
                      equipto.cd-equipto = op-ferram.ferramenta /*:screen-value in frame {&frame-name}*/ no-lock no-error.
          
           assign c-tp-ferr-descricao = if avail equipto then equipto.descricao else "":U.
    
        END.
 END.


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

  find op-altern where rowid(op-altern) = v-row-parent no-lock no-error.
  if not avail op-altern then do:
    {utp/ut-table.i mgind op-altern 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    return "adm-error":U.
  end.      

  assign rw-parent = v-row-parent.

  find operacao 
       where operacao.num-id-operacao = op-altern.num-id-operacao 
       no-lock no-error.  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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


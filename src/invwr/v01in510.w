&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V01IN510 2.00.01.004}  /*** "010104" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN510 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{include/i-vrtab.i motiv-parada}
{cdp/cdcfgman.i}
{cdp/cd0667.i}

def var v-row-parent      as rowid    no-undo.
def var c-nome-tabela     as char     no-undo.
def var l-parada-setup    as logical  no-undo.
def var l-altera-efic     as logical  no-undo.
DEF VAR l-sfc-mudancas-mi AS LOGICAL  NO-UNDO.
DEF VAR l-sfc-mudancas    AS LOGICAL INIT NO NO-UNDO.

def buffer b-motiv-parada for motiv-parada.

DEF VAR i-seq           AS INTEGER      NO-UNDO.
DEF VAR c-parametro     AS CHARACTER    NO-UNDO.
DEF VAR l-erro          AS LOGICAL      NO-UNDO.

DEF VAR hProgramZoom           AS HANDLE                            NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES motiv-parada
&Scoped-define FIRST-EXTERNAL-TABLE motiv-parada


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR motiv-parada.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS motiv-parada.des-parada motiv-parada.log-ativo ~
motiv-parada.log-alter-eficien 
&Scoped-define ENABLED-TABLES motiv-parada
&Scoped-define FIRST-ENABLED-TABLE motiv-parada
&Scoped-Define ENABLED-OBJECTS label-descricao rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS motiv-parada.cod-parada ~
motiv-parada.des-parada motiv-parada.log-ativo motiv-parada.log-alter-eficien 
&Scoped-define DISPLAYED-TABLES motiv-parada
&Scoped-define FIRST-DISPLAYED-TABLE motiv-parada
&Scoped-Define DISPLAYED-OBJECTS label-descricao fi-cod-clas-motiv ~
fi-des-clas-motiv 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS motiv-parada.cod-parada 

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
DEFINE VARIABLE fi-cod-clas-motiv AS CHARACTER FORMAT "X(8)":U 
     LABEL "Classe" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-clas-motiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE label-descricao AS CHARACTER FORMAT "X(256)":U INITIAL "Descriá∆o:" 
      VIEW-AS TEXT 
     SIZE 7.72 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.

DEFINE VARIABLE tg-email AS LOGICAL INITIAL no 
     LABEL "Envia e-mail para o Planejador do Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE tg-emite-ss AS LOGICAL INITIAL no 
     LABEL "Emite Solicitaá∆o de Serviáo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE tg-parada-setup AS LOGICAL INITIAL no 
     LABEL "Parada Setup" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     label-descricao AT ROW 2.83 COL 12 COLON-ALIGNED NO-LABEL
     motiv-parada.cod-parada AT ROW 1.17 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     motiv-parada.des-parada AT ROW 2.67 COL 19.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     motiv-parada.log-ativo AT ROW 2.67 COL 63.0 COLON-ALIGNED LABEL "Ativo"
          VIEW-AS TOGGLE-BOX 
          SIZE 18.14 BY .88
     fi-cod-clas-motiv AT ROW 3.67 COL 19.72 COLON-ALIGNED
     fi-des-clas-motiv AT ROW 3.67 COL 29 COLON-ALIGNED NO-LABEL
     motiv-parada.log-alter-eficien AT ROW 4.67 COL 14
          VIEW-AS TOGGLE-BOX
          SIZE 18.29 BY .88
     tg-emite-ss AT ROW 5.5 COL 14
     tg-parada-setup AT ROW 4.67 COL 43
     tg-email AT ROW 5.5 COL 43
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.motiv-parada
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
         HEIGHT             = 5.58
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

/* SETTINGS FOR FILL-IN motiv-parada.cod-parada IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-cod-clas-motiv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-des-clas-motiv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-email IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tg-email:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-emite-ss IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tg-emite-ss:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-parada-setup IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tg-parada-setup:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME fi-cod-clas-motiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-clas-motiv V-table-Win
ON F5 OF fi-cod-clas-motiv IN FRAME f-main /* Classe */
DO:
    &IF DEFINED(bf_man_204) &THEN
        {method/ZoomFields.i
               &ProgramZoom="mfzoom/z01mf639.w"
               &FieldZoom1="cod-clas-motiv"
               &FieldScreen1="fi-cod-clas-motiv"
               &Frame1="f-main"
               &FieldZoom2="des-clas-motiv"
               &FieldScreen2="fi-des-clas-motiv"
               &Frame2="f-main"           
               &EnableImplant="YES"}    
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-clas-motiv V-table-Win
ON LEAVE OF fi-cod-clas-motiv IN FRAME f-main /* Classe */
DO:
    &IF DEFINED(bf_man_204) &THEN
         {include/leave.i &tabela=clas-motiv 
                     &atributo-ref=des-clas-motiv
                     &variavel-ref=fi-des-clas-motiv
                     &where="clas-motiv.cod-clas-motiv = input frame {&frame-name} fi-cod-clas-motiv"}    
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-clas-motiv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-clas-motiv IN FRAME f-main /* Classe */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
fi-cod-clas-motiv:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.
    
    &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF         
    
    /************************ INTERNAL PROCEDURES ********************/
    
    ASSIGN l-sfc-mudancas-mi = NO.

    &IF DEFINED(bf_man_204) &THEN 
        RUN sfc/sf9999.p(OUTPUT l-sfc-mudancas-mi).  
    &ENDIF
    
    ASSIGN l-sfc-mudancas = l-sfc-mudancas-mi.
            
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF param-global.modulo-mi = NO THEN
        ASSIGN l-sfc-mudancas-mi = FALSE.
    
    IF l-sfc-mudancas-mi THEN DO:

        ASSIGN tg-emite-ss:HIDDEN IN FRAME {&FRAME-NAME} = FALSE
               tg-email:HIDDEN    IN FRAME {&FRAME-NAME} = FALSE.

        {utp/ut-liter.i Emite_Solicitaá∆o_de_Serviáo}
        ASSIGN tg-emite-ss:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

        {utp/ut-liter.i Envia_email_para_o_Planejador_do_Equipamento}
        ASSIGN tg-email:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
        
    END.

    IF l-sfc-mudancas = NO THEN 
        ASSIGN fi-cod-clas-motiv:HIDDEN IN FRAME {&FRAME-NAME} = YES
               fi-des-clas-motiv:HIDDEN IN FRAME {&FRAME-NAME} = YES
               motiv-parada.des-parada:ROW IN FRAME f-main     = fi-cod-clas-motiv:ROW IN FRAME f-main
               label-descricao:ROW IN FRAME f-main             = fi-cod-clas-motiv:ROW IN FRAME f-main + .1.
    ELSE 
        ASSIGN fi-cod-clas-motiv:HIDDEN IN FRAME {&FRAME-NAME} = NO
               fi-des-clas-motiv:HIDDEN IN FRAME {&FRAME-NAME} = NO.
    
    &IF DEFINED(bf_man_205) &THEN
    
        ASSIGN tg-parada-setup:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.

        {utp/ut-liter.i Parada_Setup}
        ASSIGN tg-parada-setup:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

    &ENDIF

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
  {src/adm/template/row-list.i "motiv-parada"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "motiv-parada"}

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
  &IF DEFINED(bf_man_205) &THEN
      ASSIGN tg-parada-setup:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
  &ENDIF
  
  IF l-sfc-mudancas-mi THEN DO:
      ASSIGN tg-emite-ss:CHECKED IN FRAME {&FRAME-NAME} = FALSE
             tg-email:CHECKED    IN FRAME {&FRAME-NAME} = FALSE.
  END.

  IF l-sfc-mudancas THEN 
      ASSIGN fi-cod-clas-motiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
             fi-des-clas-motiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    DISPLAY label-descricao WITH FRAME {&FRAME-NAME}.

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
    /** {include/i-valid.i} **/

    &IF DEFINED(bf_man_205) &THEN
        assign l-parada-setup = input frame {&frame-name} tg-parada-setup
               l-altera-efic  = input frame {&frame-name} motiv-parada.log-alter-eficien.
    &ENDIF
    
    if adm-new-record then do:
        find first b-motiv-parada
             where b-motiv-parada.cod-parada = input frame {&frame-name} motiv-parada.cod-parada
        no-lock no-error.
        if avail b-motiv-parada then do:
            {utp/ut-table.i mgind motiv-parada 01}
            run utp/ut-msgs.p (input 'show',
                               input 1,
                               input return-value).
            apply 'entry' to motiv-parada.cod-parada in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

    &IF DEFINED(bf_man_205) &THEN
    
        if not (adm-new-record) then do:
    
            {utp/ut-table.i mgmfg motiv-parada 01}
            assign c-nome-tabela = return-value.
               
            FIND FIRST rep-parada-geral WHERE
                rep-parada-geral.cod-parada = input frame {&FRAME-NAME} motiv-parada.cod-parada NO-LOCK NO-ERROR.
    
            IF AVAIL rep-parada-geral 
                AND motiv-parada.parada-setup = NO 
                AND motiv-parada.parada-setup <> tg-parada-setup:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
    
                {utp/ut-liter.i N∆o_Ç_poss°vel_alterar_a_parada_para_Setup_pois_a_mesma_j†_possui_parada_Geral_associada *}
                run utp/ut-msgs.p (input "show",
                                   input 17567, 
                                   input  Return-value ).
    
                apply 'entry' to tg-parada-setup in frame {&frame-name}.
                return 'ADM-ERROR':U.
    
            END.
            ELSE DO:
    
                if l-parada-setup <> input frame {&FRAME-NAME} tg-parada-setup or
                   l-altera-efic  <> input frame {&FRAME-NAME} motiv-parada.log-alter-eficien then do:

                    {utp/ut-table.i movmfg rep-parada-ctrab 01}
                    run utp/ut-msgs.p (input "show",
                                       input 17, 
                                       input c-nome-tabela + "~~" + return-value).
                    apply 'entry' to motiv-parada.des-parada in frame {&FRAME-NAME}.
                    return 'ADM-ERROR':U.
    
                end.
    
            END.
    
        end.
    
    &ENDIF
    
    &IF DEFINED(bf_man_204) &THEN
        IF l-sfc-mudancas THEN DO:

            IF fi-cod-clas-motiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:

                IF NOT CAN-FIND(FIRST clas-motiv NO-LOCK
                                WHERE clas-motiv.cod-clas-motiv = fi-cod-clas-motiv:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
                    {utp/ut-liter.i Classe_Motivo *}
                    run utp/ut-msgs.p (input "show",
                                       input 2, 
                                       input RETURN-VALUE).
                    apply 'entry' to fi-cod-clas-motiv in frame {&FRAME-NAME}.
                    return 'ADM-ERROR':U.

                END.
            END.
        END.
    &ENDIF

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAIL motiv-parada THEN DO:
      &IF DEFINED(bf_man_205) &THEN
          ASSIGN motiv-parada.parada-setup = INPUT FRAME {&FRAME-NAME} tg-parada-setup.
      &ENDIF
      
      IF l-sfc-mudancas-mi THEN DO:
  
          &IF DEFINED(bf_man_207) &THEN
              ASSIGN motiv-parada.log-emite-ss     = INPUT FRAME {&FRAME-NAME} tg-emite-ss
                     motiv-parada.log-mail-plandor = INPUT FRAME {&FRAME-NAME} tg-email.
          &ELSE
              ASSIGN OVERLAY(motiv-parada.char-1,1,1) = IF tg-emite-ss:CHECKED IN FRAME {&FRAME-NAME} THEN "S":U ELSE "N":U
                     OVERLAY(motiv-parada.char-1,2,1) = IF tg-email:CHECKED    IN FRAME {&FRAME-NAME} THEN "S":U ELSE "N":U.

          &ENDIF
  
      END.

      IF l-sfc-mudancas THEN DO:

          &IF DEFINED(bf_man_207) &THEN
          
            ASSIGN motiv-parada.cod-clas-motiv = INPUT FRAME {&FRAME-NAME} fi-cod-clas-motiv.

          &ELSE
          
            ASSIGN OVERLAY(motiv-parada.char-1,3,8) = INPUT FRAME {&FRAME-NAME} fi-cod-clas-motiv.

          &ENDIF

      END.

  END. /*avail*/

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
    
    &IF DEFINED(bf_man_205) &THEN
        DISABLE tg-parada-setup WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
    IF l-sfc-mudancas-mi THEN
        DISABLE tg-emite-ss
                tg-email WITH FRAME {&FRAME-NAME}.

    IF l-sfc-mudancas THEN
        DISABLE fi-cod-clas-motiv 
                fi-des-clas-motiv WITH FRAME  {&FRAME-NAME}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    IF AVAIL motiv-parada THEN DO:

        &IF DEFINED(bf_man_205) &THEN
            ASSIGN tg-parada-setup:CHECKED IN FRAME {&FRAME-NAME} = motiv-parada.parada-setup.
        &ENDIF
        
        IF l-sfc-mudancas-mi THEN DO:

            &IF DEFINED(bf_man_207) &THEN
            
                ASSIGN tg-emite-ss:CHECKED IN FRAME {&FRAME-NAME} = motiv-parada.log-emite-ss
                       tg-email:CHECKED    IN FRAME {&FRAME-NAME} = motiv-parada.log-mail-plandor.

            &ELSE
            
                ASSIGN tg-emite-ss:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(motiv-parada.char-1,1,1) = "S":U THEN TRUE ELSE FALSE
                       tg-email:CHECKED    IN FRAME {&FRAME-NAME} = IF SUBSTRING(motiv-parada.char-1,2,1) = "S":U THEN TRUE ELSE FALSE.

            &ENDIF

        END.

        IF l-sfc-mudancas THEN DO:
    
            &IF DEFINED(bf_man_207) &THEN
            
                ASSIGN fi-cod-clas-motiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = motiv-parada.cod-clas-motiv.
    
            &ELSE
            
                ASSIGN fi-cod-clas-motiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(motiv-parada.char-1,3,8).
    
            &ENDIF
            
            APPLY "leave":U TO fi-cod-clas-motiv IN FRAME f-main.
    
        END.
    END. /*avail*/

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
    
    &IF DEFINED(bf_man_205) &THEN
        ENABLE tg-parada-setup WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
    IF l-sfc-mudancas-mi THEN
        ENABLE tg-emite-ss
               tg-email WITH FRAME {&FRAME-NAME}.

    IF l-sfc-mudancas THEN
        ENABLE fi-cod-clas-motiv WITH FRAME {&FRAME-NAME}.
    
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
  if  avail motiv-parada then
      assign gr-motiv-parada = rowid(motiv-parada).

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
  {src/adm/template/snd-list.i "motiv-parada"}

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


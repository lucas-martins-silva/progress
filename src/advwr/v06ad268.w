&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V06AD268 2.00.00.027 } /*** "010027" ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v06ad268 MUT}
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

/* Parameters Definitions ---                                           */

{cdp/cdcfgfin.i}
{cdp/cdcfgdis.i}
/* Local Variable Definitions ---                                       */
def var wh-container  as handle    no-undo.
def var c-mensagem    as character no-undo.
def var c-handle      as character no-undo.
def var c-formato-cep as character no-undo.

def var h-bodi341      as handle no-undo.


DEF VAR c-endereco-aux LIKE emitente.endereco NO-UNDO.
DEF VAR c-rua          AS CHAR                NO-UNDO.
DEF VAR c-nro          AS CHAR                NO-UNDO.
DEF VAR c-comp         AS CHAR                NO-UNDO.
DEF VAR c-help         AS CHAR                NO-UNDO.
DEF VAR h-cdapi704     AS HANDLE              NO-UNDO.

/*Variaveis para encontrar o logradouro e numero a partir dos dados na tela*/
DEF VAR c-rua-tela  AS CHAR NO-UNDO.
DEF VAR c-nro-tela  AS CHAR NO-UNDO.
DEF VAR c-comp-tela AS CHAR NO-UNDO.

DEFINE VARIABLE h-boar2145    AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bofi230     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hProgramZoom  AS HANDLE     NO-UNDO.

/* Variaveis utilizadas para encontrar codigo do IBGE*/
DEFINE VARIABLE hlf0202d                AS HANDLE       NO-UNDO.
DEFINE VARIABLE i-cdn-munpio-ibge       AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-cdn-domic-fisc        AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-uf-Localizada         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-cdn-munpio-ibge-novo  AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-cdn-domic-fisc-novo   AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-uf-Localizada-novo    AS CHARACTER    NO-UNDO.
DEFINE BUFFER bfCidade FOR cidade.

def shared var c-ie-antiga  as CHAR no-undo.
def var        c-cod-erro   as char no-undo.
def var        c-cod-ie-sai as char no-undo.
DEF VAR        c-cod-transp AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES transporte
&Scoped-define FIRST-EXTERNAL-TABLE transporte


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR transporte.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS transporte.endereco transporte.bairro ~
transporte.cep transporte.cidade transporte.estado transporte.pais ~
transporte.cx-postal 
&Scoped-define ENABLED-TABLES transporte
&Scoped-define FIRST-ENABLED-TABLE transporte
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS transporte.endereco transporte.bairro ~
transporte.cep transporte.cidade transporte.estado transporte.pais ~
transporte.cx-postal 
&Scoped-define DISPLAYED-TABLES transporte
&Scoped-define FIRST-DISPLAYED-TABLE transporte
&Scoped-Define DISPLAYED-OBJECTS i-cod-loc-cot 

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
DEFINE VARIABLE i-cod-loc-cot AS INTEGER FORMAT "99999":U INITIAL 0 
     LABEL "C¢d Loc COT" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 8.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     transporte.endereco AT ROW 1.67 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     transporte.bairro AT ROW 2.67 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     transporte.cep AT ROW 3.67 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     transporte.cidade AT ROW 4.67 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     transporte.estado AT ROW 5.67 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     transporte.pais AT ROW 6.67 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     transporte.cx-postal AT ROW 7.67 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     i-cod-loc-cot AT ROW 7.67 COL 62.57 COLON-ALIGNED WIDGET-ID 2
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.transporte
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 8.42
         WIDTH              = 85.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN i-cod-loc-cot IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-cod-loc-cot:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME transporte.cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cep V-table-Win
ON ENDKEY OF transporte.cep IN FRAME f-main /* CEP */
DO:
    ASSIGN c-formato-cep = input frame {&FRAME-NAME} transporte.cep no-error.
    if  error-status:ERROR then do:
        assign transporte.cep:format in frame {&FRAME-NAME} = "x(12)".
    end.
    else
        ASSIGN transporte.cep:format in frame {&frame-name} = param-global.formato-cep. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cep V-table-Win
ON ENTRY OF transporte.cep IN FRAME f-main /* CEP */
DO:
  ASSIGN transporte.cep:format in frame {&frame-name} = param-global.formato-cep.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cep V-table-Win
ON LEAVE OF transporte.cep IN FRAME f-main /* CEP */
DO:
   {cdp/cd9998.i}
    /*assign c-formato-cep = input frame {&FRAME-NAME} transporte.cep no-error.
 *     if error-status:ERROR then do:
 *         assign transporte.cep:format in frame {&FRAME-NAME} = "x(12)".
 *     end.
 *     else do:
 *       if avail param-global and param-global.formato-cep <> " " then 
 *         assign transporte.cep:format in frame {&FRAME-NAME} = param-global.formato-cep.
 *     end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME transporte.cidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cidade V-table-Win
ON F5 OF transporte.cidade IN FRAME f-main /* Cidade */
DO:
  assign l-implanta = yes.
   {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                        &FieldZoom1="cidade"
                        &FieldScreen1="transporte.cidade"
                        &Frame1="f-main"
                        &FieldZoom2="estado"
                        &FieldScreen2="transporte.estado"
                        &Frame2="f-main"
                        &FieldZoom3="pais"
                        &FieldScreen3="transporte.pais"
                        &Frame3="f-main"
                        &EnableImplant="YES"}

                     
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cidade V-table-Win
ON MOUSE-SELECT-DBLCLICK OF transporte.cidade IN FRAME f-main /* Cidade */
DO:
  apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME transporte.estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.estado V-table-Win
ON F5 OF transporte.estado IN FRAME f-main /* UF */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=transporte.estado
                       &campozoom=estado
                       &campo2=transporte.pais
                       &campozoom2=pais} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.estado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF transporte.estado IN FRAME f-main /* UF */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-loc-cot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-loc-cot V-table-Win
ON F5 OF i-cod-loc-cot IN FRAME f-main /* C¢d Loc COT */
DO:
    {method/zoomfields.i &ProgramZoom="local/arg/ar2z019.w"
                         &FieldZoom1="cdn-localid-cot"
                         &FieldScreen1="i-cod-loc-cot"
                         &Frame1="{&frame-name}"
                         &FieldZoom2="cod-zip-code"
                         &FieldScreen2="transporte.cep"
                         &Frame2="{&frame-name}"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-loc-cot V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-loc-cot IN FRAME f-main /* C¢d Loc COT */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME transporte.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.pais V-table-Win
ON F5 OF transporte.pais IN FRAME f-main /* Pa°s */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=transporte.pais
                       &campozoom=pais
                       &campo2=transporte.estado
                       &campozoom2=estado} 


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF transporte.pais IN FRAME f-main /* Pa°s */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

  if transporte.cidade:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.  
  if transporte.estado:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if transporte.pais:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name} then.
  if i-cod-loc-cot:load-mouse-pointer     ('image/lupa.cur')  in frame {&frame-name} then.

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

  if   avail param-global then do:
       find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
       if   avail empresa then 
            assign transporte.pais:screen-value in frame {&frame-name} = empresa.pais.
  end.          

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-cod-loc-aux AS INT NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

   /* Ponha aqui as demais validaá‰es */
  find unid-feder no-lock where 
       unid-feder.pais   = input frame {&frame-name} transporte.pais and
       unid-feder.estado = input frame {&frame-name} transporte.estado no-error.
  if  not avail unid-feder then do:
      RUN Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-handle).
      assign wh-container = widget-handle(c-handle).
      run select-page in wh-container (1). 
      {utp/ut-field.i mgadm transporte pais 1}
      assign c-mensagem = return-value.
      {utp/ut-field.i mgadm transporte estado 1}
      assign c-mensagem = c-mensagem + "/" + return-value.
      run utp/ut-msgs.p (input "show", input 47, input c-mensagem).
      apply "entry" to transporte.estado.
      return "adm-error".
  end.

     /* valida cidade */
      if (param-global.dec-1 = 1) then do:

          if not valid-handle(h-bodi341) then
              run dibo/bodi341.p persistent set h-bodi341.

          run openQueryStatic in h-bodi341 (input "Default":U).

          run goToKey in h-bodi341 (input input frame {&FRAME-NAME} transporte.cidade,
                                    input input frame {&FRAME-NAME} transporte.estado,
                                    input input frame {&FRAME-NAME} transporte.pais).

          if return-value <> "OK":U then do:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Cidade" *}
              run utp/ut-msgs.p (input "show",
                                 input  2,
                                 input RETURN-VALUE).
              apply "ENTRY" to transporte.cidade.
              return "ADM-ERROR":U.
          end.
      end.
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */


    /****** Verifica se ouve alteracao nos seguintes campos: pais, logradouro, numero, cdn-munpio-ibge, bairro
                           Chama o programa para atualizacao dos dados do transporte ********************/
    
    IF AVAIL transporte
    AND i-pais-impto-usuario = 1
    AND CONNECTED("mgfis") THEN
    DO:
        /*PAIS*/
        IF transporte.pais <> transporte.pais:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN
        DO:
            RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
            ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
            RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                            INPUT 4,
                                            INPUT transporte.pais,
                                            INPUT transporte.pais:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT 04).
            DELETE PROCEDURE h-bofi230.
            ASSIGN h-bofi230 = ?.
        END.
        
        /*COD-IBGE*/
        FOR FIRST cidade NO-LOCK
            WHERE cidade.cidade = transporte.cidade:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            AND   cidade.estado = transporte.estado:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            AND   cidade.pais   = transporte.pais:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
        END.
        
        IF NOT AVAIL cidade
        OR 
            &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
            cidade.cdn-munpio-ibge = ?
            &ELSE
            cidade.int-2 = ?
            &ENDIF
        THEN
        DO:
            RUN lfp/lf0202d.p PERSISTENT SET hlf0202d.
            RUN initializeInf IN hlf0202d.
            RUN returnCityInf IN hlf0202d (INPUT  transporte.cidade,
                                           INPUT  transporte.estado, 
                                           OUTPUT i-cdn-munpio-ibge,
                                           OUTPUT i-cdn-domic-fisc,
                                           OUTPUT c-uf-Localizada).
            RUN returnCityInf IN hlf0202d (INPUT  transporte.cidade:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           INPUT  transporte.estado:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           OUTPUT i-cdn-munpio-ibge-novo,
                                           OUTPUT i-cdn-domic-fisc-novo,
                                           OUTPUT c-uf-Localizada-novo).
            RUN finalizeInf   IN hlf0202d.
            DELETE PROCEDURE hlf0202d.  
            ASSIGN hlf0202d = ?.
        
            IF i-cdn-munpio-ibge <> i-cdn-munpio-ibge-novo THEN DO:

                RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
                ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
                RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                                INPUT 4,
                                                INPUT i-cdn-munpio-ibge,
                                                INPUT i-cdn-munpio-ibge-novo,
                                                INPUT 08).
                DELETE PROCEDURE h-bofi230.
                ASSIGN h-bofi230 = ?.

            END.
            
        END.
        ELSE
        DO:
            FIND FIRST bfCidade NO-LOCK
                 WHERE bfCidade.cidade = transporte.cidade
                 AND   bfCidade.estado = transporte.estado
                 AND   bfCidade.pais   = transporte.pais   NO-ERROR.
           
            IF AVAIL bfCidade
            AND
                &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                bfCidade.cdn-munpio-ibge <> cidade.cdn-munpio-ibge
                &ELSE
                bfCidade.int-2 <> cidade.int-2
                &ENDIF
            THEN
            DO:
                RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
                ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
                RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                                INPUT 4,
                                                INPUT 
                                                &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                                                     bfCidade.cdn-munpio-ibge
                                                     &ELSE
                                                     bfCidade.int-2
                                                     &ENDIF
                                                     ,
                                                INPUT
                                                     &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                                                     cidade.cdn-munpio-ibge
                                                     &ELSE
                                                     cidade.int-2
                                                     &ENDIF
                                                     ,
                                                INPUT 08).
                DELETE PROCEDURE h-bofi230.
                ASSIGN h-bofi230 = ?.    
            END.
        END.

        /*INSCRIÄ«O ESTADUAL*/
        IF  transporte.estado <> transporte.estado:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        AND transporte.ins-estadual <> c-ie-antiga THEN DO:

            RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
            run cdp/cd6667.p(input  transporte.pais,
                             Input  transporte.estado,
                             Input  c-ie-antiga,
                             Output c-cod-erro,
                             Output c-cod-ie-sai).

            IF c-cod-erro = "OK" THEN DO: 
                ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
                RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                                INPUT 4,
                                                INPUT c-ie-antiga,
                                                INPUT transporte.ins-estadual,
                                                INPUT 07).
            END.
            ELSE DO:
                ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
                RUN eliminaRegistro IN h-bofi230(INPUT c-cod-transp,
                                                 INPUT 4,
                                                 INPUT 07).
            END.
            DELETE PROCEDURE h-bofi230.
            ASSIGN h-bofi230 = ?.
        END.
        
        /*Metodo que busca o logradouro e o n£mero*/
        IF NOT VALID-HANDLE(h-cdapi704) THEN
            RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
        RUN pi-trata-endereco IN h-cdapi704 (INPUT transporte.endereco, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).
        RUN pi-trata-endereco IN h-cdapi704 (INPUT transporte.endereco:SCREEN-VALUE IN FRAME {&FRAME-NAME}, OUTPUT c-rua-tela, OUTPUT c-nro-tela, OUTPUT c-comp-tela).
        DELETE PROCEDURE h-cdapi704.
        ASSIGN h-cdapi704 = ?.
                              
        /*LOGRADOURO*/
        IF c-rua <> c-rua-tela THEN
        DO:
            RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
            ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
            RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                            INPUT 4,
                                            INPUT c-rua,
                                            INPUT c-rua-tela,
                                            INPUT 10).
            DELETE PROCEDURE h-bofi230.
            ASSIGN h-bofi230 = ?.
        END.

        /*NUMERO*/
        IF c-nro <> c-nro-tela THEN
        DO:
            RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
            ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
            RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                            INPUT 4,
                                            INPUT c-nro,
                                            INPUT c-nro-tela,
                                            INPUT 11).
            DELETE PROCEDURE h-bofi230.
            ASSIGN h-bofi230 = ?.
        END.
        
        
        /*BAIRRO*/
        IF transporte.bairro <> transporte.bairro:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN
        DO:
            RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
            ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp).
            RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                            INPUT 4,
                                            INPUT transporte.bairro,
                                            INPUT transporte.bairro:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT 13).
            DELETE PROCEDURE h-bofi230.
            ASSIGN h-bofi230 = ?.
        END.
    END.
    
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN i-cod-loc-aux = INT(i-cod-loc-cot:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.
  
  /* Code placed here will execute AFTER standard behavior.    */
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN OVERLAY(transporte.char-1,1,5) = STRING(i-cod-loc-aux,"99999").
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  IF VALID-HANDLE(h-cdapi704) THEN DO:
      DELETE PROCEDURE h-cdapi704.
      ASSIGN h-cdapi704 = ?.
  END.

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  VALID-HANDLE(h-boar2145) THEN DO:
          RUN destroy IN h-boar2145.
          ASSIGN h-boar2145 = ?.
      END.
  END.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
    
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN i-cod-loc-cot:SENSITIVE IN FRAME {&frame-name} = NO.

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

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        IF  AVAIL transporte THEN
            ASSIGN i-cod-loc-cot = INT(SUBSTR(transporte.char-1,1,5)).
        ELSE
            ASSIGN i-cod-loc-cot = 0.

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
  
   IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
       ASSIGN i-cod-loc-cot:SENSITIVE IN FRAME {&frame-name} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  find first param-global no-lock no-error.

  &if defined(BF_FIN_EMS2_X_MG) &then
      if can-find(first funcao where funcao.cd-funcao = "spp-ems2fin-x-mg"
                               and   funcao.ativo     = yes) then
         assign transporte.estado:format in frame {&frame-name} = "x(02)".
  &endif

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  NOT VALID-HANDLE(h-boar2145) THEN
          RUN local/arg/boar2145.p PERSISTENT SET h-boar2145.

      ASSIGN i-cod-loc-cot:HIDDEN IN FRAME {&frame-name} = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-uf V-table-Win 
PROCEDURE pi-retorna-uf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-unid-feder like transporte.estado.

    assign p-unid-feder = input frame {&FRAME-NAME} transporte.estado.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF CAN-FIND(FIRST pais WHERE 
                     pais.nome-pais = INPUT FRAME {&FRAME-NAME} transporte.pais AND
                     pais.int-2     <> 1) THEN DO:

      IF NOT VALID-HANDLE(h-cdapi704) THEN
         RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

      RUN pi-trata-endereco IN h-cdapi704 (INPUT INPUT FRAME {&FRAME-NAME} transporte.endereco, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).

      ASSIGN c-endereco-aux = c-rua +
                              IF c-nro <> "" AND c-comp <> "" THEN " " + c-nro + " " + c-comp
                                                              ELSE ""
             c-endereco-aux = c-endereco-aux +
                               IF c-nro <> "" AND c-comp = "" THEN " " + c-nro ELSE ""
             c-endereco-aux = c-endereco-aux +
                               IF c-nro = "" AND c-comp <> "" THEN " " + c-comp ELSE "".

       IF c-nro = "" THEN DO:

          ASSIGN c-help = "N∆o foi poss°vel identificar no endereáo informado os componentes Logradouro e N£mero do Endereáo. Veja abaixo exemplo de formatos v†lidos:" + CHR(13) + 
                           "AV. PRESIDENTE COSTA E SILVA, 1178 - SALA 5" + CHR(13) + 
                           "AV. GETÈLIO VARGAS 1178 TêRREO"              + CHR(13) + 
                           "MARGINAL DA VIA ANCHIETA, KM 23"             + CHR(13) + 
                           "RUA MARECHAL DEODORO NR. 251"                + CHR(13) + 
                           "RUA VISCONDE DE MAUA N.1890 ED. SENTRA"      + CHR(13) + 
                           "AV ANTONIO DE CARVALHO 2600/3108"            + CHR(13) + 
                           "AV. TEODOMIRO DA FONSECA, 2173 BL1"          + CHR(13) + 
                           "RODOVIA BR 101 - KM29 - IGARASSU"            + CHR(13) + 
                           "RUA XV DE NOVEMBRO AP. 121 Nr 415"           + CHR(13) + 
                           "AV. BANDEIRA GOMES S/N - ED.MEDSERV"         + CHR(13) + 
                           "RUA 1650, NR 900, BLOCO 2".

          IF CAN-FIND(FIRST pais WHERE 
                            pais.nome-pais = INPUT FRAME {&FRAME-NAME} transporte.pais AND
                            pais.int-2     = 2) THEN DO: /* Advertencia */
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Formato_do_endereáo_do_transportador_desconhecido._Deseja_continuar?" *}
              RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT  27100,
                                INPUT RETURN-VALUE + "~~" + c-help).

               IF RETURN-VALUE = "NO":U THEN DO:
                 APPLY "ENTRY" TO transporte.endereco IN FRAME {&FRAME-NAME}.
                 RETURN 'adm-error':U.
              END.
          END.
    
          IF CAN-FIND(FIRST pais WHERE 
                            pais.nome-pais = INPUT FRAME {&FRAME-NAME} transporte.pais AND
                            pais.int-2     = 3) THEN DO: /* Com Bloqueio */
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Formato_do_endereáo_do_transportador_inv†lido" *}
              RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT  17006,
                                INPUT RETURN-VALUE + "." + "~~" + c-help).
              APPLY "ENTRY" TO transporte.endereco IN FRAME {&FRAME-NAME}.
              RETURN 'adm-error':U.
          END.
       END.

   END.

    IF  i-pais-impto-usuario = 2 /* Argentina */  
    and int(i-cod-loc-cot:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN DO:
        IF  VALID-HANDLE(h-boar2145) THEN DO:
            RUN validaLocCOT IN h-boar2145 (INPUT transporte.cep:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT i-cod-loc-cot:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
            IF  RETURN-VALUE = "NOK" THEN DO:
                {utp/ut-liter.i "C¢digo_LOC" *}
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT  56,
                                   INPUT RETURN-VALUE).
                APPLY "ENTRY" TO i-cod-loc-cot IN FRAME {&FRAME-NAME}.
                RETURN 'adm-error':U.
            END.
        END.
    END.

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


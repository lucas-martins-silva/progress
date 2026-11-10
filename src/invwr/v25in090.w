&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V25IN090 2.00.00.022 } /*** "010022" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V25IN090 MUT}
&ENDIF

{cdp/cdcfgmat.i}

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

def var rw-saldo-terc as rowid no-undo.
def var rw-docum-est  as rowid no-undo.

DEF VAR h-boar2016 AS HANDLE NO-UNDO.

def var h-re1701     as handle no-undo.
def var c-handle     as char   no-undo.
DEF VAR h-bocx378    AS HANDLE NO-UNDO.
DEF VAR l-tem-import AS LOG NO-UNDO.

{cdp/cd4300.i3}  /* Variaveis para o cd4300.i4   */
{cdp/cd0101.i50} /* Variaveis para o re1001b.i51 */
{rep/re1001a.i50}  /* variaveis e informacoes utilizadas pelo re1001a.i51 */

DEFINE VARIABLE h-boec022 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin01066 AS HANDLE      NO-UNDO.
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER   NO-UNDO.
DEF NEW GLOBAL SHARED VAR GR-DOCUM-EST AS ROWID NO-UNDO.

DEF VAR c-decl-aduana AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.cod-estabel docum-est.dt-trans ~
docum-est.dt-emissao 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS rt-mold c-decla-import 
&Scoped-Define DISPLAYED-FIELDS docum-est.esp-docto docum-est.cod-estabel ~
docum-est.estab-de-or docum-est.dt-trans docum-est.dt-emissao 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS fi-esp-docto cb-tipo-nota l-movimentacao ~
c-cod-autoriz-sri d-dat-autoriz-sri cb-cod-observa fi-estabel ~
fi-estabel-origem c-natureza fi-natureza tg-log-entreg-fut c-decla-import ~
c-despacho c-cod-natur-vincul fi-natureza-vinc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS docum-est.esp-docto cb-cod-observa ~
docum-est.cod-estabel docum-est.estab-de-or docum-est.dt-trans ~
docum-est.dt-emissao c-natureza 
&Scoped-define ADM-MODIFY-FIELDS cb-cod-observa 

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
DEFINE VARIABLE cb-cod-observa AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Ind£stria","Com‚rcio","Devolu‡Æo Cliente","Servi‡os" 
     DROP-DOWN-LIST
     SIZE 27.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-nota AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 21.43 BY 1 NO-UNDO.

DEFINE VARIABLE l-movimentacao AS CHARACTER FORMAT "X(12)":U INITIAL "0" 
     LABEL "" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-autoriz-sri AS CHARACTER FORMAT "X(37)":U 
     LABEL "Autoriz SRI" 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-natur-vincul AS CHARACTER FORMAT "X(06)" 
     LABEL "":R22 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-decla-import AS CHARACTER FORMAT "X(20)":U 
     LABEL "Declara‡Æo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-despacho AS CHARACTER FORMAT "X(20)":U 
     LABEL "DP" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X.XX-XXX":U 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-dat-autoriz-sri AS DATE FORMAT "99/99/9999":U 
     LABEL "DT Autoriz" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-esp-docto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-natureza AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-natureza-vinc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78.86 BY 11.5.

DEFINE VARIABLE tg-log-entreg-fut AS LOGICAL INITIAL no 
     LABEL "":L17 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.esp-docto AT ROW 1.33 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-esp-docto AT ROW 1.33 COL 29 COLON-ALIGNED NO-LABEL
     cb-tipo-nota AT ROW 1.33 COL 54.57 COLON-ALIGNED
     l-movimentacao AT ROW 2.38 COL 21.29 COLON-ALIGNED
     c-cod-autoriz-sri AT ROW 3.5 COL 21.29 COLON-ALIGNED
     d-dat-autoriz-sri AT ROW 3.5 COL 63.29 COLON-ALIGNED
     cb-cod-observa AT ROW 3.54 COL 21.29 COLON-ALIGNED
     docum-est.cod-estabel AT ROW 4.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-estabel AT ROW 4.71 COL 28.29 COLON-ALIGNED NO-LABEL
     docum-est.estab-de-or AT ROW 5.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-estabel-origem AT ROW 5.71 COL 28.29 COLON-ALIGNED NO-LABEL
     docum-est.dt-trans AT ROW 6.75 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.dt-emissao AT ROW 7.75 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-natureza AT ROW 8.75 COL 21.29 COLON-ALIGNED
     fi-natureza AT ROW 8.75 COL 31.57 COLON-ALIGNED NO-LABEL
     tg-log-entreg-fut AT ROW 9.75 COL 23.29 HELP
          "Nota de Entrega Futura?"
     c-decla-import AT ROW 9.75 COL 59 COLON-ALIGNED WIDGET-ID 6
     c-despacho AT ROW 9.75 COL 59 COLON-ALIGNED WIDGET-ID 2
     c-cod-natur-vincul AT ROW 10.75 COL 21.29 COLON-ALIGNED HELP
          "Natureza de Opera‡Æo Vinculada"
     fi-natureza-vinc AT ROW 10.75 COL 31.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.docum-est
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
         HEIGHT             = 11.5
         WIDTH              = 79.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-autoriz-sri IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-autoriz-sri:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-natur-vincul IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-natur-vincul:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-despacho IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-despacho:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-natureza IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR COMBO-BOX cb-cod-observa IN FRAME f-main
   NO-ENABLE 2 3                                                        */
ASSIGN 
       cb-cod-observa:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-tipo-nota IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-tipo-nota:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN docum-est.cod-estabel IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN d-dat-autoriz-sri IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       d-dat-autoriz-sri:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN docum-est.dt-emissao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.dt-trans IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.esp-docto IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN docum-est.estab-de-or IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-esp-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-natureza-vinc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-natureza-vinc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX l-movimentacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-log-entreg-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-log-entreg-fut:HIDDEN IN FRAME f-main           = TRUE.

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

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF

  {utp/ut-field.i mgind item-doc-est nat-comp 1}
  assign c-natureza:label in frame {&frame-name} = return-value.
  /* Aguardando o label do dicionÿrio ser alterado para COD OBSERVA°€O
   * {utp/ut-field.i mgind docum-est cod-observa 1} */
  {utp/ut-liter.i Cod_Observa‡Æo * L}     
  assign cb-cod-observa:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    IF  VALID-HANDLE(h-boar2016) THEN
        RUN destroy IN h-boar2016.

    IF  VALID-HANDLE(h-boin01066) THEN
        RUN destroy IN h-boin01066.

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
  if  avail docum-est then do:
      find emitente where 
           emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
      find natur-oper where
           natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
      find estabelec where
           estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.

      assign l-movimentacao:screen-value in frame {&frame-name} = ?.
      disable l-movimentacao with frame {&frame-name}.
      if avail emitente and avail natur-oper then do:
         if emitente.identific = 3 and 
            natur-oper.tipo = 1    then do:
             assign l-movimentacao:screen-value = {varinc/var00072.i 04 2} /*"Fornecedor"*/.
         end.
         else do:
              if emitente.identific = 1 and 
                 natur-oper.tipo = 1   then do:
                 assign l-movimentacao:screen-value = {varinc/var00072.i 04 1} /*"Cliente"*/.
             end.
             ELSE DO:
                 if emitente.identific = 2 and 
                     natur-oper.tipo = 1   then do:
                     assign l-movimentacao:screen-value = {varinc/var00072.i 04 2} /*"Fornecedor"*/.
                 end.
             END.
         end.
      end.
      assign fi-esp-docto    = {ininc/i03in218.i 04 docum-est.esp-docto}.
      if avail estabelec then
         assign fi-estabel      = estabelec.nome.
      find estabelec where
           estabelec.cod-estabel = docum-est.estab-de-or no-lock no-error.
      assign fi-estabel-origem = if avail estabelec then estabelec.nome else "".

      &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
        IF i-pais-impto-usuario <> 1 THEN DO WITH FRAME {&FRAME-NAME}:
           
            ASSIGN c-cod-natur-vincul = docum-est.cod-natur-vincul
                   tg-log-entreg-fut  = docum-est.log-entreg-fut.

            FIND natur-oper WHERE
                 natur-oper.nat-operacao = docum-est.cod-natur-vincul NO-LOCK NO-ERROR.
    
            IF AVAIL natur-oper THEN
                ASSIGN fi-natureza-vinc = natur-oper.denominacao.
            ELSE 
                ASSIGN fi-natureza-vinc = "".

            DISPLAY c-cod-natur-vincul
                    fi-natureza-vinc
                    tg-log-entreg-fut.
        END.
      &ENDIF

  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if  avail docum-est then do with frame {&frame-name}:
      assign cb-cod-observa:screen-value = 
                            {ininc/i03in090.i 04 docum-est.cod-observa}.
  end.
  else do with frame {&frame-name}:
      assign cb-cod-observa:screen-value = {ininc/i03in090.i 04 1}.
  end.

  IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo)
    AND AVAIL docum-est THEN DO:
        IF  NOT VALID-HANDLE(h-boar2016) THEN
            RUN local/arg/boar2016.p PERSISTENT SET h-boar2016.

        RUN retornaDespachoPlaza IN h-boar2016 (INPUT i-ep-codigo-usuario,
                                                INPUT docum-est.serie-docto,
                                                INPUT docum-est.nro-docto,
                                                INPUT docum-est.nat-operacao,
                                                INPUT docum-est.cod-emitente,
                                                OUTPUT c-despacho).
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-despacho.
    END.
  
    
    IF CAN-FIND(FIRST funcao 
       WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo) 
                AND VALID-HANDLE(h-boin01066) THEN DO:

        ASSIGN c-decla-import:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

      
        RUN goToKey IN h-boin01066(INPUT docum-est.serie-docto,
                                  INPUT docum-est.nro-docto,
                                  INPUT docum-est.cod-emitente,
                                  INPUT docum-est.nat-operacao).

        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boin01066(INPUT "declaracao-import":U,
                                            OUTPUT c-decl-aduana).
      
            ASSIGN c-decla-import:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-decl-aduana.
        END.
        ELSE DO:
            ASSIGN c-decla-import:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".   
        END.
    END.
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
    if adm-new-record = yes then
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
 
  {utp/ut-liter.i Movimenta‡Æo_com * L}
  assign l-movimentacao:label in frame {&frame-name} = return-value.

  do with frame {&FRAME-NAME}:
    assign cb-cod-observa:list-items = {ininc/i03in090.i 03}.
    assign l-movimentacao:list-items = {varinc/var00072.i 03}.
    
  end.

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
    IF i-pais-impto-usuario <> 1 THEN DO:

        {utp/ut-liter.i Entrega_Futura * L}
        ASSIGN tg-log-entreg-fut:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
        {utp/ut-liter.i Natur_Vinculada * L}
        ASSIGN c-cod-natur-vincul:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
        
        ASSIGN tg-log-entreg-fut:HIDDEN  IN FRAME {&FRAME-NAME} = NO
               c-cod-natur-vincul:HIDDEN IN FRAME {&FRAME-NAME} = NO
               fi-natureza-vinc:HIDDEN   IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE 
        ASSIGN rt-mold:HEIGHT IN FRAME {&FRAME-NAME} = 9.50.
  &ELSE 
       ASSIGN rt-mold:HEIGHT IN FRAME {&FRAME-NAME} = 9.50.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo) THEN
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = NO.
    ELSE 
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = YES.


  IF CAN-FIND(FIRST funcao 
    WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo) THEN DO:

      RUN inbo/boin01066.p PERSISTENT SET h-boin01066.
     
      RUN openQueryStatic IN h-boin01066 (INPUT "Main":U).
        
      ASSIGN c-decla-import:HIDDEN IN FRAME {&FRAME-NAME} = NO
             c-decla-import:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE DO:
      ASSIGN c-decla-import:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  END.
  apply "leave" to l-movimentacao in frame {&frame-name}.

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

  RUN Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-handle).
  assign h-re1701 = widget-handle(c-handle).

  /* Code placed here will execute AFTER standard behavior.    */

  IF  h-re1701:NAME = "rep~\re1701.w":U OR 
      h-re1701:NAME = "rep/re1701.w":U  THEN DO:
      
          IF  NOT AVAIL param-global THEN
              FIND FIRST param-global NO-LOCK NO-ERROR.
          
          ASSIGN l-tem-import = NO.
          
          IF  param-global.modulo-07 AND AVAIL docum-est THEN DO:
              RUN cxbo/bocx378.p PERSISTENT SET h-bocx378.
              RUN openQueryStatic IN h-bocx378 ("").
              RUN goToKey2 IN h-bocx378 (INPUT docum-est.serie-docto,
                                         INPUT docum-est.nro-docto,
                                         INPUT docum-est.cod-emitente,
                                         INPUT docum-est.nat-operacao).
              IF  RETURN-VALUE = "OK":U THEN
                  ASSIGN l-tem-import = YES.
              
              DELETE PROCEDURE h-bocx378.
    
              /*Verifica se o documento ² de importa»’o para notas fiscais complementares*/
              IF l-tem-import = NO THEN DO:
                  {cdp/cd4300.i4  "yes" docum-est.char-1}
                  {rep/re1001a.i51 "yes"}
                
                  IF TRIM(c-embarque) <> "" THEN ASSIGN l-tem-import = YES.
              END.
          END.
          
          RUN pi-desab-bt-dup-imp in h-re1701 (INPUT l-tem-import).
                       
  END.
 

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
  {src/adm/template/snd-list.i "docum-est"}

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


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
{include/i-prgvrs.i V05AD229 2.00.00.024 } /*** "010024" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05AD229 MUT}
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

/* Miniflexibilizaá∆o */
{include/i_dbvers.i}
{cdp/cdcfgfin.i}
{cdp/cdcfgdis.i}
{include/i_fnctrad.i}

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var i-modalidade as int no-undo.
def var i-port-aux as int no-undo.
def var c-endereco-bkp as char no-undo.
def var cLista         as char no-undo.
def var c-formato-cep  as character no-undo.

DEF VAR c-endereco-aux LIKE emitente.endereco NO-UNDO.
DEF VAR c-rua          AS CHAR                NO-UNDO.
DEF VAR c-nro          AS CHAR                NO-UNDO.
DEF VAR c-comp         AS CHAR                NO-UNDO.
DEF VAR c-help         AS CHAR                NO-UNDO.
DEF VAR h-cdapi704     AS HANDLE              NO-UNDO.


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
&Scoped-define EXTERNAL-TABLES repres
&Scoped-define FIRST-EXTERNAL-TABLE repres


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR repres.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS repres.endereco repres.bairro repres.cidade ~
repres.estado repres.pais repres.cep repres.caixa-postal repres.Complemento ~
repres.telefone[1] repres.telefone[2] repres.telefax repres.e-mail 
&Scoped-define ENABLED-TABLES repres
&Scoped-define FIRST-ENABLED-TABLE repres
&Scoped-Define ENABLED-OBJECTS end-completo rt-mold 
&Scoped-Define DISPLAYED-FIELDS repres.endereco repres.bairro repres.cidade ~
repres.estado repres.pais repres.cep repres.caixa-postal repres.Complemento ~
repres.telefone[1] repres.telefone[2] repres.telefax repres.e-mail 
&Scoped-define DISPLAYED-TABLES repres
&Scoped-define FIRST-DISPLAYED-TABLE repres
&Scoped-Define DISPLAYED-OBJECTS end-compl end-completo cb-modalidade 

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
DEFINE VARIABLE cb-modalidade AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS COMBO-BOX INNER-LINES 7
     DROP-DOWN-LIST
     SIZE 16.57 BY 1 NO-UNDO.

DEFINE VARIABLE end-completo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 66.14 BY 1.5 TOOLTIP "Endereáo Completo" NO-UNDO.

DEFINE VARIABLE end-compl AS CHARACTER FORMAT "X(15)":U 
     LABEL "End. Completo" 
      VIEW-AS TEXT 
     SIZE .86 BY .67 TOOLTIP "Endereáo Completo" NO-UNDO.

DEFINE VARIABLE i-portador AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Portador para Geraá∆o do AD" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 9.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     end-compl AT ROW 1.54 COL 16.29 RIGHT-ALIGNED
     end-completo AT ROW 1.42 COL 17.43 NO-LABEL
     repres.endereco AT ROW 3 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.29 BY .88
     repres.bairro AT ROW 3 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     repres.cidade AT ROW 4 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.29 BY .88
     repres.estado AT ROW 4 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     repres.pais AT ROW 5 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.29 BY .88
     repres.cep AT ROW 5 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
     repres.caixa-postal AT ROW 6 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     repres.Complemento AT ROW 7 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38.43 BY .88
     repres.telefone[1] AT ROW 8 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     repres.telefone[2] AT ROW 8 COL 65.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     repres.telefax AT ROW 9 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     i-portador AT ROW 9 COL 55.29 COLON-ALIGNED
     cb-modalidade AT ROW 9 COL 62.43 COLON-ALIGNED NO-LABEL
     repres.e-mail AT ROW 10.04 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38.43 BY .88
     rt-mold AT ROW 1.17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.repres
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
         HEIGHT             = 10.08
         WIDTH              = 84.72.
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

/* SETTINGS FOR COMBO-BOX cb-modalidade IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-modalidade:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN end-compl IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN i-portador IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       i-portador:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME repres.cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.cep V-table-Win
ON ENDKEY OF repres.cep IN FRAME f-main /* CEP */
DO:
    ASSIGN c-formato-cep = input frame {&FRAME-NAME} repres.cep no-error.
    if  error-status:ERROR then do:
        assign repres.cep:format in frame {&FRAME-NAME} = "x(12)".
    end.
    ELSE
        assign repres.cep:format in frame {&FRAME-NAME} = param-global.formato-cep.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.cep V-table-Win
ON ENTRY OF repres.cep IN FRAME f-main /* CEP */
DO:
    assign repres.cep:format in frame {&FRAME-NAME} = param-global.formato-cep.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.cep V-table-Win
ON LEAVE OF repres.cep IN FRAME f-main /* CEP */
DO:
  {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME repres.estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.estado V-table-Win
ON F5 OF repres.estado IN FRAME f-main /* UF */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom = "unzoom/z01un007.w"
                     &campo=repres.estado
                     &campozoom=estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.estado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF repres.estado IN FRAME f-main /* UF */
DO:
   apply 'F5' to self.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-portador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-portador V-table-Win
ON F5 OF i-portador IN FRAME f-main /* Portador para Geraá∆o do AD */
DO:
   {include/zoomvar.i &prog-zoom="adzoom/z01ad209.w"
                      &campo=i-portador
                      &campozoom=cod-portador
                      &campo2=cb-modalidade
                      &campozoom2=c-modalidade}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-portador V-table-Win
ON LEAVE OF i-portador IN FRAME f-main /* Portador para Geraá∆o do AD */
DO:
  assign i-port-aux = input frame {&frame-name} i-portador.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-portador V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-portador IN FRAME f-main /* Portador para Geraá∆o do AD */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME repres.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.pais V-table-Win
ON F5 OF repres.pais IN FRAME f-main /* Pa°s */
DO:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom = "unzoom/z01un006.w"
                     &campo=repres.pais
                     &campozoom=nome-pais}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF repres.pais IN FRAME f-main /* Pa°s */
DO:
 apply 'F5' to self.
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

if repres.estado:load-mouse-pointer       ("image/lupa.cur") in frame {&frame-name} then.
if repres.pais:load-mouse-pointer         ("image/lupa.cur") in frame {&frame-name} then.

run pi-versao (input 5).

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
  {src/adm/template/row-list.i "repres"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "repres"}

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
   &if  defined(bf_fin_4linhas_end) &then 
      assign end-completo:screen-value in frame {&FRAME-NAME} = "". 
  &endif      
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

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

  run pi-validate.
  if  return-value = 'adm-error' then
      return 'adm-error'.

  run pi-versao (input 7).

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  run pi-versao (input 8).   

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

  run pi-versao(input 2).

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign end-completo:sensitive in frame {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

   find first param-global no-lock no-error.
   assign repres.cep:format in frame {&FRAME-NAME} = param-global.formato-cep.

   run pi-versao (input 4).

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

  if NOT can-find (
      first funcao 
      where funcao.cd-funcao = "Repres 2.00" 
      or funcao.cd-funcao = "Representantes 2.00") then do:

      run pi-versao(input 3).

      RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

      assign repres.cep:format in frame {&frame-name} = "x(12)".  

      /* Code placed here will execute AFTER standard behavior.    */

      &if  defined(bf_fin_4linhas_end) &then
          assign end-completo:sensitive    in frame {&FRAME-NAME} = yes.
      &endif

      if adm-new-record = yes then
      &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      &endif
  END.

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

  find first param-global no-lock no-error.

  &if defined(BF_FIN_EMS2_X_MG) &then
      if  can-find(first funcao
                   where funcao.cd-funcao = "spp-ems2fin-x-mg"
                   and   funcao.ativo     = yes) then
          assign repres.estado:format in frame {&frame-name} = "X(02)"
                 repres.bairro:format in frame {&frame-name} = "x(15)".

  &endif

  run pi-versao(input 1).    

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   ASSIGN end-completo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

   &if  defined(bf_fin_4linhas_end) &then
       assign end-completo:visible in frame {&FRAME-NAME} = yes.
       assign end-compl:visible in frame  {&FRAME-NAME} = yes.
   &else
       assign end-completo:visible in frame {&FRAME-NAME} = no.
       assign end-compl:visible in frame  {&FRAME-NAME} = no.
   &endif


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-uf V-table-Win 
PROCEDURE pi-retorna-uf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-unid-feder like repres.estado.

    assign p-unid-feder = input frame {&FRAME-NAME} repres.estado.
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

  if  input frame {&frame-name} repres.endereco = "" then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 4860,
                         input "").
      apply "entry" to repres.endereco in frame {&frame-name}.
      Return 'adm-error':U.
  end. 

  if  input frame {&frame-name} repres.cidade = "" then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 2822,
                         input "").
      apply "entry" to repres.cidade in frame {&frame-name}.
      Return 'adm-error':U.
  end.

  find pais where pais.nome-pais = input frame {&frame-name} repres.pais no-lock no-error.
  if  not avail pais then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show" ,
                         input  964,
                         input "").
      apply "entry" to repres.pais in frame {&frame-name}.
      Return 'adm-error':U.
  end.                      

  if  input frame {&frame-name} repres.pais = "Brasil" then do:
      if  input frame {&frame-name} repres.cep = "" then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show",
                             input 192,
                             input "").
          apply "entry" to repres.cep in frame {&frame-name}.
          Return 'adm-error':U.
      end.
  end.

  find first unid-feder 
       where unid-feder.pais = input frame {&frame-name} repres.pais
       and unid-feder.estado = input frame {&frame-name} repres.estado 
       no-lock no-error.

  if  not avail unid-feder then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 4259,
                         input "").
      apply "entry" to repres.estado in frame {&frame-name}.
      Return 'adm-error':U.
  end.      

      find first param-global no-lock no-error.
      if param-global.dec-1 <> 0 then do:
        find first cidade
             where cidade.cidade = input frame {&frame-name} repres.cidade
             and   cidade.estado = input frame {&frame-name} repres.estado
             and   cidade.pais   = input frame {&frame-name} repres.pais
           no-lock no-error.
        if not avail cidade then do:
           run utp/ut-msgs.p (input "show",
                              input 27180,
                              input "").
           apply "entry" to repres.cidade in frame {&frame-name}.
           Return 'adm-error':U.
        end.
      end.

      IF CAN-FIND(FIRST pais WHERE 
                         pais.nome-pais = INPUT FRAME {&FRAME-NAME} repres.pais AND
                         pais.int-2     <> 1) THEN DO:
    
          IF NOT VALID-HANDLE(h-cdapi704) THEN
             RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
    
          RUN pi-trata-endereco IN h-cdapi704 (INPUT INPUT FRAME {&FRAME-NAME} repres.endereco, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).
    
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
                               "AV. GETÈLIO VARGAS 1178 T?RREO"              + CHR(13) + 
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
                                pais.nome-pais = INPUT FRAME {&FRAME-NAME} repres.pais AND
                                pais.int-2     = 2) THEN DO: /* Advertencia */
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "Formato_do_endereáo_do_representante_desconhecido._Deseja_continuar?" *}
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                    INPUT  27100,
                                    INPUT RETURN-VALUE + "~~" + c-help).
    
                   IF RETURN-VALUE = "NO":U THEN DO:
                     APPLY "ENTRY" TO repres.endereco IN FRAME f-main.
                     RETURN 'adm-error':U.
                  END.
              END.
        
              IF CAN-FIND(FIRST pais WHERE 
                                pais.nome-pais = INPUT FRAME {&FRAME-NAME} repres.pais AND
                                pais.int-2     = 3) THEN DO: /* Com Bloqueio */
                  /* Inicio -- Projeto Internacional */
                  {utp/ut-liter.i "Formato_do_endereáo_do_representante_inv†lido" *}
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                    INPUT  17006,
                                    INPUT RETURN-VALUE + "." + "~~" + c-help).
                  APPLY "ENTRY" TO repres.endereco IN FRAME f-main.
                  RETURN 'adm-error':U.
              END.
           END.
    
      END.


  run pi-versao(input 6).
  if return-value = "adm-error" then
     return "adm-error":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-versao V-table-Win 
PROCEDURE pi-versao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Miniflexibilizaá∆o */

    def input param p-ind as int no-undo.
    &if "{&mgadm_version}" >= "2.02" &then
        vers_block:
        do:
            &if "{&mgadm_version}" = "2.02" &then
                find first histor_exec_especial no-lock
                   where histor_exec_especial.cod_modul_dtsul = 'CRP'
                   and   histor_exec_especial.cod_prog_dtsul  = 'EMS_202_GERA_AD_BANCO' no-error.
                if  not avail histor_exec_especial then 
                    leave vers_block.  
            &endif 

            case p-ind:
                when 1 then do: /* initialize */
                    assign i-portador:visible      in frame {&FRAME-NAME} = yes 
                           i-portador:sensitive    in frame {&FRAME-NAME} = no
                           i-portador:hidden       in frame {&FRAME-NAME} = no
                           cb-modalidade:visible   in frame {&FRAME-NAME} = yes 
                           cb-modalidade:sensitive in frame {&FRAME-NAME} = no
                           cb-modalidade:hidden    in frame {&FRAME-NAME} = no.
                    do  with frame {&frame-name}:
                        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                            assign cLista = {adinc/i03ad209.i 03}.
                            run utp/ut-lstit.p (input-output cLista).
                            assign cb-modalidade:list-item-pairs   = cLista.
                        &else
                            assign cb-modalidade:list-items = {adinc/i03ad209.i 03}.
                        &endif         
                    end.                
                end.    
                when 2 then do: /* disable */
                    assign i-portador:sensitive    in frame {&FRAME-NAME} = no
                           cb-modalidade:sensitive in frame {&FRAME-NAME} = no.


                end.
                when 3 then do: /* enable */
                    find first param-cr
                         where param-cr.ep-codigo = i-ep-codigo-usuario no-lock no-error.
                    if  avail param-cr then
                        if  param-cr.gera-movto = 2 then do:
                            assign i-portador:sensitive    in frame {&FRAME-NAME} = yes
                                   cb-modalidade:sensitive in frame {&FRAME-NAME} = yes.
                        end.        
                    if  input frame {&FRAME-NAME} i-portador = 0 then do:   
                        assign i-modalidade = 1
                               input frame {&frame-name} cb-modalidade i-modalidade = {adinc/i03ad209.i 06 cb-modalidade}.
                        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                            assign cLista = {adinc/i03ad209.i 03}.
                            run utp/ut-lstit.p (input-output cLista).
                            assign cb-modalidade:list-item-pairs   = cLista.
                        &else
                            assign cb-modalidade:list-items = {adinc/i03ad209.i 03}.
                        &endif 
                    end.
                end.               
                when 4 then do: /* display-field */    
                    if  avail repres then do with frame {&frame-name}:
                        find first portador 
                             where portador.cod-portador = repres.cod-portador-geracao-ad
                             and   portador.modalidade   = repres.int-1 no-lock no-error.
                        if  avail portador then do:
                            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                                assign cLista = {adinc/i03ad209.i 03}.
                                run utp/ut-lstit.p (input-output cLista).
                                assign cb-modalidade:list-item-pairs   = cLista.
                            &else
                                assign cb-modalidade:list-items = {adinc/i03ad209.i 03}.
                            &endif                         
                            assign i-portador:screen-value    in frame {&FRAME-NAME} = string(portador.cod-portador)
                                   cb-modalidade:screen-value in frame {&frame-name} = {adinc/i03ad209.i 04 portador.modalidade}.                 
                        end.           
                        else do: 
                            assign i-portador:screen-value  = string(i-port-aux).    
                        end. 
                        &if  defined(bf_fin_4linhas_end) &then
                             assign end-completo:SCREEN-VALUE in frame {&FRAME-NAME} = repres.endereco_text.                             
                        &endif
                    end. 
                end.    
                when 5 then /* main block */
                    if i-portador:load-mouse-pointer       ("image/lupa.cur") in frame {&frame-name} then.
                when 6 then do: /* pi-validate */
                    if  i-portador:sensitive    in frame {&FRAME-NAME} = yes then do:
                        assign input frame {&frame-name} cb-modalidade i-modalidade = {adinc/i03ad209.i 06 cb-modalidade}
                               i-portador = input frame {&FRAME-NAME} i-portador.
                        find first portador
                             where portador.cod-portador = i-portador
                             and   portador.modalidade   = i-modalidade no-lock no-error.
                        if  not avail portador then do:
                            run utp/ut-msgs.p (input "show",
                                               input 798,
                                               input i-portador:screen-value + "~~" + cb-modalidade:screen-value).
                            apply 'entry' to i-portador in frame {&FRAME-NAME}.
                            return 'adm-error':U.
                        end.     
                    end.    
                end. 
                when 7 then do: /* assign */
                    &IF  DEFINED(bf_fin_4linhas_end) &THEN
                         assign c-endereco-bkp = end-completo:SCREEN-VALUE in frame {&FRAME-NAME}.
                    &ENDIF

                    if  i-portador:sensitive    in frame {&FRAME-NAME} = yes then do:
                        assign input frame {&frame-name} cb-modalidade i-modalidade = {adinc/i03ad209.i 06 cb-modalidade}
                               i-portador = input frame {&FRAME-NAME} i-portador.                                  
                    end.          
                    else do:
                        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                            assign cLista = ",".
                            run utp/ut-lstit.p (input-output cLista).
                            assign cb-modalidade:list-item-pairs   = cLista.
                        &else
                            assign cb-modalidade:list-items = "".
                        &endif         
                    end.               
                end.
                when 8 then do:  /* assign */
                  if  i-portador:sensitive    in frame {&FRAME-NAME} = yes then do:
                        if  avail repres then 
                            assign repres.cod-portador-geracao-ad = i-portador
                                   repres.int-1                   = i-modalidade.

                    end.           
                    &if  defined(bf_fin_4linhas_end) &then
                        IF AVAIL repres THEN DO:
                            if INPUT frame {&FRAME-NAME} end-completo = "" then do:
                                assign end-completo:SCREEN-VALUE in frame {&FRAME-NAME} = c-endereco-bkp
                                       repres.endereco_text                             = c-endereco-bkp.
                            end.
                            else do:
                                assign repres.endereco_text = INPUT frame {&FRAME-NAME} end-completo.
                            end.
                        END.
                    &endif
                end.          
            end case.             
        end.
    &endif 

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
  {src/adm/template/snd-list.i "repres"}

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


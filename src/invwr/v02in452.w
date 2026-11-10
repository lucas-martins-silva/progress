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
{include/i-prgvrs.i V02IN452 2.00.01.010}  /*** 010110 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in452 MUT}
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

/* global variable definitions */
def new global shared var r-parent as rowid no-undo. 
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-mo-codigo    like modelo-cf.mo-codigo.
def var c-it-codigo    like item.it-codigo.
def var i-sequencia    like estr-mod-cf.sequencia.
def var c-fm-codigo    like familia.fm-codigo.
def var c-sub-modelo   like estr-mod-cf.sub-modelo.
def var de-quant-usada like estr-mod-cf.quant-usada.
def var v-row-table    as   rowid no-undo.

{cdp/cdcfgman.i}

{cdp/cdapi020.i}
{cdp/cd0666.i}

def temp-table tt-var-aux like tt-var.

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
&Scoped-define EXTERNAL-TABLES estr-mod-cf
&Scoped-define FIRST-EXTERNAL-TABLE estr-mod-cf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estr-mod-cf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold c-campo-formula 
&Scoped-Define DISPLAYED-OBJECTS c-campo-formula 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-campo-formula 

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
DEFINE VARIABLE c-campo-formula AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 59.72 BY 5.54.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64 BY 6.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-campo-formula AT ROW 1.63 COL 3.43 NO-LABEL
     rt-mold AT ROW 1.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estr-mod-cf
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
         HEIGHT             = 7.04
         WIDTH              = 65.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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

/* SETTINGS FOR EDITOR c-campo-formula IN FRAME f-main
   2                                                                    */
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

&IF DEFINED (bf_man_204) &THEN
    {cdp/cdapi020.i13}
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
  {src/adm/template/row-list.i "estr-mod-cf"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estr-mod-cf"}

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

  assign c-campo-formula:screen-value in frame {&frame-name} = "".

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "quant-usada").



  assign de-quant-usada = decimal(return-value).
  assign c-campo-formula:sensitive in frame {&frame-name} = 
         if de-quant-usada = ? then yes else no.

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
  /* Code placed here will execute PRIOR to standard behavior. */
  /*{include/i-valid.i}*/
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . */

   if  RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

  run get-attribute ('adm-new-record').


   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "it-codigo":U).

 assign c-it-codigo  = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "sequencia":U).
 assign i-sequencia  = int(return-value).

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "fm-codigo":U).

 assign c-fm-codigo  = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "sub-modelo":U).

 assign c-sub-modelo = return-value.

 /* A consistencia abaixo foi comentada, por que estava matando o valor da variavel         */
 /* "i-sequencia" carregado no Get-Field acima, causando problemas na inclus∆o da Formula   */
 /* ap¢s o primeiro a inclus∆o do primeiro item.                                            */

/*  find first estr-mod-cf where rowid(estr-mod-cf) = v-row-table */
/*       no-lock no-error.                                        */
/*  IF avail estr-mod-cf THEN                                     */
/*     assign i-sequencia = estr-mod-cf.sequencia.                */

 find modelo-cf where rowid(modelo-cf) = r-parent no-lock no-error.
 if avail modelo-cf then assign c-mo-codigo = modelo-cf.mo-codigo. 

 &IF DEFINED (bf_man_204) &THEN
    if input frame {&frame-name} c-campo-formula <> "" then do:
        run pi-testa-formula(input frame {&frame-name} c-campo-formula).

        if can-find (first tt-erro) then do:
            run cdp/cd0666.w (input table tt-erro).
            return "adm-error".
        end.    
    end.
 &ENDIF            

 /*Alterado devido ao projeto da copamex */
 IF input frame {&frame-name} c-campo-formula <> "" THEN DO:
     find estr-mod-for where estr-mod-for.mo-codigo  = c-mo-codigo
                         and estr-mod-for.it-codigo  = c-it-codigo
                         and estr-mod-for.fm-codigo  = c-fm-codigo
                         and estr-mod-for.sub-modelo = c-sub-modelo
                         and estr-mod-for.sequencia  = i-sequencia EXCLUSIVE-LOCK no-error.
    
       if  not avail estr-mod-for then
           create estr-mod-for.
    
       assign estr-mod-for.mo-codigo  = c-mo-codigo
              estr-mod-for.it-codigo  = c-it-codigo
              estr-mod-for.fm-codigo  = c-fm-codigo
              estr-mod-for.sub-modelo = c-sub-modelo
              estr-mod-for.sequencia  = i-sequencia
              estr-mod-for.formula    = input frame {&frame-name} c-campo-formula.
                      
 END.

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



  /* Dispatch standard ADM method.                             */
   /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "it-codigo").

 assign c-it-codigo  = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT  "sequencia" ).
 assign i-sequencia  = int(return-value).

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "fm-codigo").

 assign c-fm-codigo  = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT  "sub-modelo" ).

 assign c-sub-modelo = return-value.

 find modelo-cf where rowid(modelo-cf) = r-parent no-lock no-error.
 if avail modelo-cf then assign c-mo-codigo = modelo-cf.mo-codigo. 

 find estr-mod-for where estr-mod-for.mo-codigo  = c-mo-codigo
                     and estr-mod-for.it-codigo  = c-it-codigo
                     and estr-mod-for.fm-codigo  = c-fm-codigo
                     and estr-mod-for.sub-modelo = c-sub-modelo
                     and estr-mod-for.sequencia  = i-sequencia NO-LOCK no-error.

 if avail estr-mod-for then 
    assign c-campo-formula:screen-value in frame {&frame-name} = estr-mod-for.formula.
 else   
    assign c-campo-formula:screen-value in frame {&frame-name} = "" .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "quant-usada").



 assign de-quant-usada = decimal(return-value).
 assign c-campo-formula:sensitive in frame {&frame-name} = 
        if de-quant-usada = ? then yes else no.

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

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                 INPUT "it-codigo":U).

   assign c-it-codigo  = return-value.

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                 INPUT "sequencia":U).
   assign i-sequencia  = int(return-value).

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                 INPUT "fm-codigo":U).

   assign c-fm-codigo  = return-value.

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                 INPUT "sub-modelo":U).

   assign c-sub-modelo = return-value.

   find modelo-cf where rowid(modelo-cf) = r-parent no-lock no-error.
   if avail modelo-cf then assign c-mo-codigo = modelo-cf.mo-codigo. 

   FIND estr-mod-for where estr-mod-for.mo-codigo  = c-mo-codigo
                       and estr-mod-for.it-codigo  = c-it-codigo
                       and estr-mod-for.fm-codigo  = c-fm-codigo
                       and estr-mod-for.sub-modelo = c-sub-modelo
                       and estr-mod-for.sequencia  = i-sequencia NO-LOCK no-error.

   if avail estr-mod-for then DO:
      assign c-campo-formula:screen-value in frame {&frame-name} = estr-mod-for.formula.
   END.
   ELSE DO:   
      assign c-campo-formula:screen-value in frame {&frame-name} = "" .
   END.

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                  INPUT "quant-usada":U).



   assign de-quant-usada = decimal(return-value).
   assign c-campo-formula:sensitive in frame {&frame-name} = 
          if de-quant-usada = ? then yes else no.

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

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-formula V-table-Win 
PROCEDURE pi-atualiza-formula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-habilita as logical.

assign c-campo-formula:sensitive in frame {&frame-name}= l-habilita.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-formula V-table-Win 
PROCEDURE pi-limpa-formula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN c-campo-formula:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

find estr-mod-for where estr-mod-for.mo-codigo  = c-mo-codigo
                         and estr-mod-for.it-codigo  = c-it-codigo
                         and estr-mod-for.fm-codigo  = c-fm-codigo
                         and estr-mod-for.sub-modelo = c-sub-modelo
                         and estr-mod-for.sequencia  = i-sequencia EXCLUSIVE-LOCK no-error.
    IF AVAIL estr-mod-for THEN
        delete estr-mod-for.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-v-row-table V-table-Win 
PROCEDURE pi-seta-v-row-table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter p-row-table as rowid no-undo.

        assign v-row-table = p-row-table.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-testa-formula V-table-Win 
PROCEDURE pi-testa-formula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input param c-formula as char.
  def var i-cont     as int initial 1.
  def var i-tipo-res as int no-undo.

  for each tt-formula:
      delete tt-formula.
  end.
  for each tt-erro:
      delete tt-erro.
  end.    
  for each tt-var:
      delete tt-var.
  end.    

  for each tt-var-aux:
      delete tt-var-aux.
  end.

  run pi-retorna-variaveis (input c-formula, output table tt-var).

  create tt-formula.
  assign tt-formula.formula               = c-formula
         tt-formula.cod-versao-integracao = 001
         tt-formula.sequencia             = 1.

  for each tt-var:
      find var-modelo where var-modelo.nome-var  = tt-var.nome and
                            var-modelo.mo-codigo = modelo-cf.mo-codigo no-error.
      find constante where constante.nome-cte = tt-var.nome no-error.
      if not avail constante and not avail var-modelo THEN DO:
         DEFINE VARIABLE c-texto1 AS CHARACTER  NO-UNDO.
         {utp/ut-liter.i Vari†vel *}
         assign c-texto1 = return-value.
         {utp/ut-liter.i n∆o_cadastrada. *}
         create tt-erro.
         assign tt-erro.mensagem = c-texto1 + " " + tt-var.nome + " " + return-value
                tt-erro.cd-erro  = 0.

         RETURN "NOK":U.
      END.
  end.

  for each tt-var:
      find var-modelo where var-modelo.nome-var  = tt-var.nome and
                            var-modelo.mo-codigo = modelo-cf.mo-codigo no-error.      
      if avail var-modelo then do:
          if var-modelo.tipo-result =  7 then
              assign i-tipo-res = 4.
          else
              assign i-tipo-res = var-modelo.tipo-result.      
          create tt-var-aux.    
          assign tt-var-aux.nome      = tt-var.nome
                 tt-var-aux.valor     = 1
                 tt-var-aux.texto     = var-modelo.descricao
                 tt-var-aux.nr-tabela = var-modelo.nr-tabela
                 tt-var-aux.abrev-nar = var-modelo.abreviatura
                 tt-var-aux.sequencia = var-modelo.sequencia.
                 tt-var-aux.tipo-res  = i-tipo-res.
      end.
      else do:
          find constante where constante.nome-cte = tt-var.nome no-error.
          if avail constante then do:
              find last tt-var-aux where
                        tt-var-aux.nome = tt-var.nome no-error.
              if avail tt-var-aux then
                  assign i-cont = tt-var-aux.sequencia + 1.
              else
                  assign i-cont = 1.

              create tt-var-aux.
              assign tt-var-aux.nome      = tt-var.nome
                     tt-var-aux.valor     = 1
                     tt-var-aux.texto     = constante.descricao
                     tt-var-aux.nr-tabela = 0
                     tt-var-aux.abrev-nar = ""
                     tt-var-aux.sequencia = i-cont
                     tt-var-aux.tipo-res  = 1.
          end.
      end.
  end.

/*   run cdp/cdapi020.p (input-output table tt-formula, input table tt-var-aux, input-output table tt-erro, input yes). */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/

  def var c-formula     like estr-mod-reg.regra.
  def var i-tam         as integer.
  def var i-inicio      as integer. 
  def var i-cont-asp    as integer.
  def var i-cont-apos   as integer. 
  def var i-cont-para   as integer. 
  def var i-cont-parf   as integer.
  def var i-cont-colcha as integer. 
  def var i-cont-colchf as integer.
  def var l-desfaz      as logical.
  def var i-fim         as integer. 
  def var c-var-comp    as char.
  def var c-mensagem    as char.


  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */


  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "it-codigo").
  assign c-it-codigo  = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT  "sequencia" ).
  assign i-sequencia  = int(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "fm-codigo").
  assign c-fm-codigo  = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT  "sub-modelo" ).
  assign c-sub-modelo = return-value.


  find modelo-cf where rowid(modelo-cf) = r-parent no-lock no-error.
  if avail modelo-cf then assign c-mo-codigo = modelo-cf.mo-codigo. 

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "quant-usada").
  assign de-quant-usada  = decimal(return-value).


  if de-quant-usada = ? and input frame {&frame-name} c-campo-formula = ""  
  then do:
     {include/i-vldprg.i} 
     run utp/ut-msgs.p (input "show",
                        input 8814,
                        input "").
     apply "ENTRY" to c-campo-formula  in frame {&frame-name}.
     return "ADM-ERROR":U.         
  end.   

  if de-quant-usada <> ? or de-quant-usada <> 0 then  
     return.

  if de-quant-usada <> ? and input frame {&frame-name} c-campo-formula <> "" 
     and not adm-new-record then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 6667,
                         input "").     
      if return-value = "yes" then do:
         assign c-campo-formula:screen-value in frame {&frame-name} = "".
      end.
  end. 

/************************ CONSISTE REGRA *******************************/ 


  /* Validaá∆o da Sintaxe */

  assign c-formula = input frame {&frame-name} c-campo-formula.
         i-tam   = 0.

  assign i-inicio    = 0
         i-tam       = length(c-formula)
         i-cont-asp  = 0
         i-cont-apos = 0
         i-cont-para = 0
         i-cont-parf = 0
         l-desfaz    = no.
  b-regra:
  repeat:
    assign i-fim = i-inicio + 1.
    if  i-fim > i-tam then do:
        if  i-cont-asp modulo 2 > 0 then do:
            {utp/ut-liter.i Aspas mcf c}  
            assign c-mensagem = return-value.
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 6821,
                               input c-mensagem).     
             apply "ENTRY" to c-campo-formula  in frame {&frame-name}.
             return "ADM-ERROR":U.         
        end.
        if  i-cont-apos modulo 2 > 0 then do:
            {utp/ut-liter.i Ap¢strofes mcf c}  
            assign c-mensagem = return-value.
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 6821,
                               input c-mensagem).     
             apply "ENTRY" to c-campo-formula  in frame {&frame-name}.
             return "ADM-ERROR":U.         

        end.
        if  i-cont-para <> i-cont-parf then do:
            {utp/ut-liter.i Parànteses mcf c}  
            assign c-mensagem = return-value.
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 6821,
                               input c-mensagem).     
             apply "ENTRY" to c-campo-formula  in frame {&frame-name}.
             return "ADM-ERROR":U.         

        end.
        if l-desfaz then
           next b-regra.
        if ((i-cont-asp  = 0) or (i-cont-apos = 0) or 
            (i-cont-para = i-cont-parf)) then
            leave b-regra.
    end.
    if  substr(c-formula,i-fim,1) = '"'   then 
        assign i-cont-asp  = i-cont-asp  + 1.
    if  substr(c-formula,i-fim,1) = "'"   then
        assign i-cont-apos = i-cont-apos + 1.
    if  substr(c-formula,i-fim,1) = "(" then
        assign i-cont-para = i-cont-para + 1.
    if  (substr(c-formula,i-fim,1) = ")") then
        assign i-cont-parf = i-cont-parf + 1.
    if  substr(c-formula,i-fim,1) = "[" then
        assign i-cont-colcha = i-cont-colcha + 1.
    if  (substr(c-formula,i-fim,1) = "]") then
        assign i-cont-colchf = i-cont-colchf + 1.
    i-inicio = i-fim.
  end.
  

  if (i-cont-asp  modulo 2 <> 0)    or
     (i-cont-apos modulo 2 <> 0)    or
     i-cont-para   <> i-cont-parf   or
     i-cont-colcha <> i-cont-colchf then do:
     {include/i-vldprg.i}
     {utp/ut-liter.i F¢rmula MCF L}
     run utp/ut-msgs.p (input "show",
                        input 7333,
                        input trim(return-value)).     
  end.

  /* Validaá∆o das Vari†veis e Constantes */



  c-formula = replace(c-formula,"<>","&").
  c-formula = replace(c-formula,">","&").
  c-formula = replace(c-formula,"<","&").
  c-formula = replace(c-formula,"=","&"). 
  c-formula = replace(c-formula,">=","&").
  c-formula = replace(c-formula,"<=","&").
  c-formula = replace(c-formula,"(","&").
  c-formula = replace(c-formula,")","&").
  c-formula = replace(c-formula,"[","&").
  c-formula = replace(c-formula,"]","&").
  c-formula = replace(c-formula," + ","&").
  c-formula = replace(c-formula," - ","&").
  c-formula = replace(c-formula," / ","&").
  c-formula = replace(c-formula," * ","&").
  c-formula = replace(c-formula," ","").
  c-formula = replace(c-formula,'"',"'").
  c-formula = replace(c-formula," ","&").
  c-formula = "&" + c-formula + "&".
  c-formula = replace(c-formula,"&&","&").


  assign i-inicio = 1
         i-tam    = length(c-formula).
  repeat:
    assign i-fim = i-inicio + 1.
    if i-fim > i-tam then leave.
    i-fim = index(c-formula,"&",i-fim).
    c-var-comp = trim(
                 substr(c-formula, i-inicio + 1, (i-fim - i-inicio - 1))).
    if c-var-comp <> "" then do:
        if  (index("0123456789'",(substr(c-var-comp,1,1))) = 0) then do:
            find first var-modelo 
               where var-modelo.nome-var = c-var-comp
               no-lock no-error.
            if not available var-modelo then do:
               find first constante
                    where constante.nome-cte = c-var-comp
                    no-lock no-error.
               if not avail constante then do:
                  {include/i-vldprg.i}
                  run utp/ut-msgs.p (input "show",
                                     input 6820,
                                     input c-var-comp).     
               end.
            end.
        end.
    end.
    i-inicio = i-fim.
  end.

  /*************************************************************************/


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
  {src/adm/template/snd-list.i "estr-mod-cf"}

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


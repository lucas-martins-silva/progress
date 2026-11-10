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
{include/i-prgvrs.i V02IN453 2.00.01.010}  /*** 010110 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN453 MUT}
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

/* Parameters Definitions ---                                           */
def new global shared var r-parent as rowid no-undo.

/* Local Variable Definitions ---                                       */

def var c-mo-codigo    like modelo-cf.mo-codigo.
def var c-it-codigo    like item.it-codigo.
def var i-sequencia    like estr-mod-cf.sequencia.
def var c-fm-codigo    like familia.fm-codigo.
def var c-sub-modelo   like estr-mod-cf.sub-modelo.
def var de-quant-usada like estr-mod-cf.quant-usada.

def var c-regra     like estr-mod-reg.regra.
def var i-tam         as integer.
def var i-inicio      as integer. 
def var i-cont-asp    as integer.
def var i-cont-apos   as integer. 
def var i-cont-para   as integer. 
def var i-cont-parf   as integer.
def var l-desfaz      as logical.
def var i-fim         as integer. 
def var c-var-comp    as char.
def var c-mensagem    as char.

def var c-sim         as char.

{cdp/cdcfgman.i}

def var h-handle as handle no-undo.  
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
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estr-mod-cf
&Scoped-define FIRST-EXTERNAL-TABLE estr-mod-cf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estr-mod-cf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-regra-exist rt-mold 
&Scoped-Define DISPLAYED-OBJECTS c-regra-exist 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define ADM-ASSIGN-FIELDS c-regra-exist 

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
DEFINE VARIABLE c-regra-exist AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 5
     FONT 2.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64 BY 6.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-regra-exist AT ROW 2 COL 3 NO-LABEL
     rt-mold AT ROW 1.25 COL 1
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
         HEIGHT             = 7.08
         WIDTH              = 65.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{utp/ut-glob.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR c-regra-exist IN FRAME F-Main
   2                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
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
  HIDE FRAME F-Main.
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

  assign c-regra-exist:screen-value in frame {&frame-name} = "".

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

  {include/i-valid.i}
  
  /* Dispatch standard ADM method.                             */
  
 run get-attribute ('adm-new-record').
 
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
 * 
 *   if  RETURN-VALUE = 'ADM-ERROR':U then 
 *       RETURN 'ADM-ERROR':U.*/

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

 &IF DEFINED (bf_man_204) &THEN
    if input frame {&frame-name} c-regra-exist <> "" then do:
        run pi-testa-formula(input frame {&frame-name} c-regra-exist).
        if return-value = "adm-error":U then return "adm-error":U.

        run pi-finalizar in h-handle.        
    end.
 &ENDIF             
 
find estr-mod-reg where estr-mod-reg.mo-codigo  = c-mo-codigo
                    and estr-mod-reg.it-codigo  = c-it-codigo
                    and estr-mod-reg.fm-codigo  = c-fm-codigo
                    and estr-mod-reg.sub-modelo = c-sub-modelo
                    and estr-mod-reg.sequencia  = i-sequencia exclusive-lock no-error.
if not avail estr-mod-reg then do:
    if input frame {&frame-name} c-regra-exist <> "" then do:
        create estr-mod-reg.      
        assign estr-mod-reg.mo-codigo   = c-mo-codigo
               estr-mod-reg.it-codigo   = c-it-codigo
               estr-mod-reg.fm-codigo   = c-fm-codigo
               estr-mod-reg.sub-modelo  = c-sub-modelo
               estr-mod-reg.sequencia   = i-sequencia
               estr-mod-reg.regra-exist = input frame {&frame-name} c-regra-exist.
    end.
end.
else do:
    if input frame {&frame-name} c-regra-exist = "" then do:
        delete estr-mod-reg.
    end.
    else do:
        if estr-mod-reg.regra-exist <> input frame {&frame-name} c-regra-exist then
            assign estr-mod-reg.regra-exist = input frame {&frame-name} c-regra-exist.
    end.
end.
         
/* Code placed here will execute AFTER standard behavior.    */

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
 
 find estr-mod-reg where estr-mod-reg.mo-codigo  = c-mo-codigo
                     and estr-mod-reg.it-codigo  = c-it-codigo
                     and estr-mod-reg.fm-codigo  = c-fm-codigo
                     and estr-mod-reg.sub-modelo = c-sub-modelo
                     and estr-mod-reg.sequencia  = i-sequencia NO-LOCK no-error.
                     
  if  avail estr-mod-reg then
      assign c-regra-exist:screen-value in frame {&frame-name} = estr-mod-reg.regra-exist.
  else
      assign c-regra-exist:screen-value in frame {&frame-name} = "".


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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
 
  /* Code placed here will execute AFTER standard behavior.    */


/*RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
 *                                                 INPUT "it-codigo":U).
 *       
 *  assign c-it-codigo  = return-value.
 *  
 *  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
 *                                                 INPUT "sequencia":U).
 *  assign i-sequencia  = int(return-value).
 *  
 *  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
 *                                                 INPUT "fm-codigo":U).
 *                                                 
 *  assign c-fm-codigo  = return-value.
 *  
 *  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
 *                                                 INPUT "sub-modelo":U).
 *                                                 
 *  assign c-sub-modelo = return-value.
 *  
 *  find modelo-cf where rowid(modelo-cf) = r-parent no-lock no-error.
 *  if avail modelo-cf then assign c-mo-codigo = modelo-cf.mo-codigo.
 *  
 *  find estr-mod-reg where estr-mod-reg.mo-codigo  = c-mo-codigo
 *                      and estr-mod-reg.it-codigo  = c-it-codigo
 *                      and estr-mod-reg.fm-codigo  = c-fm-codigo
 *                      and estr-mod-reg.sub-modelo = c-sub-modelo
 *                      and estr-mod-reg.sequencia  = i-sequencia no-error.
 *                      
 *   if  avail estr-mod-reg then
 *       assign c-regra-exist:screen-value in frame {&frame-name} = estr-mod-reg.regra-exist.
 *   else
 *       assign c-regra-exist:screen-value in frame {&frame-name} = "".
 * */


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
  
  {utp/ut-liter.i Sim *}
  assign c-sim = trim(return-value).
   
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF DEFINED (bf_man_204) &THEN
    run cdp/cdapi020.p persistent set h-handle (input-output table tt-formula,
                                                input        table tt-var,
                                                input-output table tt-erro, 
                                                input        yes).
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */
  
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
  def var i-cont     as int initial 1 no-undo.
  def var i-erro     as integer no-undo.
  def var c-erro     as char    no-undo.  
  def var i-tipo-res as integer no-undo. 
  
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

  for each tt-var:
      find var-modelo where var-modelo.nome-var  = tt-var.nome and
                            var-modelo.mo-codigo = modelo-cf.mo-codigo no-error.      
      IF NOT AVAIL var-modelo THEN DO:
          ASSIGN c-mensagem = '"' + tt-var.nome + '"'.
          run utp/ut-msgs.p (input "show",
                             input 6118,
                             input c-mensagem).     
           apply "ENTRY" to c-regra-exist  in frame {&frame-name}.
           return "ADM-ERROR":U.         
      END.

      find constante where constante.nome-cte = tt-var.nome no-error.
      if not avail constante and not avail var-modelo then
          delete tt-var.
          
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


  &IF DEFINED (bf_man_204) &THEN
    run cdp/cdapi020.p persistent set h-handle (input-output table tt-formula,
                                                input        table tt-var,
                                                input-output table tt-erro, 
                                                input        yes).
  &ENDIF






  if valid-handle(h-handle) and h-handle:file-name = 'cdapi020' then 
  run pi-analisa-expressao in h-handle (input c-formula,
                                        input table tt-var-aux).
    
  run pi-retorna-erro in h-handle (output i-erro,
                                   output c-erro).
    

  if i-erro > 0 then do: 
     run utp/ut-msgs.p (input "show",
                        input i-erro,
                        input c-erro).
     return "adm-error".
  end.                        

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

   {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                               INPUT "quant-usada":U).
 
 assign de-quant-usada  = decimal(return-value).
  
  if de-quant-usada <> ? or de-quant-usada <> 0 then  
     return.

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


 /************************ CONSISTE REGRA *******************************/ 

  /* Valida‡Æo da Sintaxe */

  assign c-regra = input frame {&frame-name} c-regra-exist.
         i-tam   = 0.

  assign i-inicio    = 0
         i-tam       = length(c-regra)
         i-cont-asp  = 0
         i-cont-apos = 0
         i-cont-para = 0
         i-cont-parf = 0
         l-desfaz    = no.
         
  if c-regra = " " or 
     c-regra = ? then return.       
         
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
             apply "ENTRY" to c-regra-exist  in frame {&frame-name}.
             return "ADM-ERROR":U.         
        end.
        if  i-cont-apos modulo 2 > 0 then do:
            {utp/ut-liter.i Ap¢strofes mcf c}  
            assign c-mensagem = return-value.
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 6821,
                               input c-mensagem).     
             apply "ENTRY" to c-regra-exist  in frame {&frame-name}.
             return "ADM-ERROR":U.         

        end.
        if  i-cont-para <> i-cont-parf then do:
            {utp/ut-liter.i Parˆnteses mcf c}  
            assign c-mensagem = return-value.
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 6821,
                               input c-mensagem).     
             apply "ENTRY" to c-regra-exist  in frame {&frame-name}.
             return "ADM-ERROR":U.         

        end.
        if l-desfaz then
           next b-regra.
        if ((i-cont-asp  = 0) or (i-cont-apos = 0) or 
            (i-cont-para = i-cont-parf)) then
            leave b-regra.
    end.
    if  substr(c-regra,i-fim,1) = '"'   then 
        assign i-cont-asp  = i-cont-asp  + 1.
    if  substr(c-regra,i-fim,1) = "'"   then
        assign i-cont-apos = i-cont-apos + 1.
    if  substr(c-regra,i-fim,1) = "(" then
        assign i-cont-para = i-cont-para + 1.
    if  (substr(c-regra,i-fim,1) = ")") then
        assign i-cont-parf = i-cont-parf + 1.
    i-inicio = i-fim.
  end.

  if (i-cont-asp  modulo 2 <> 0)    or
     (i-cont-apos modulo 2 <> 0)    or
     i-cont-para   <> i-cont-parf   then do:
     {include/i-vldprg.i}
     {utp/ut-liter.i Regra_de_Existˆncia MCF L}
     run utp/ut-msgs.p (input "show",
                        input 7333,
                        input trim(return-value)).     
  end.

  /* Valida‡Æo das Vari veis e Constantes */

  c-regra = replace(c-regra,"<>","&").
  c-regra = replace(c-regra,">","&").
  c-regra = replace(c-regra,"<","&").
  c-regra = replace(c-regra,"=","&"). 
  c-regra = replace(c-regra,">=","&").
  c-regra = replace(c-regra,"<=","&").
  c-regra = replace(c-regra,"(","&").
  c-regra = replace(c-regra,")","&").
  c-regra = replace(c-regra," and ","&").
  c-regra = replace(c-regra," or ","&").
  c-regra = replace(c-regra," ","").
  c-regra = replace(c-regra,'"',"'").
  c-regra = replace(c-regra," ","&").  
  c-regra = "&" + c-regra + "&".
  c-regra = replace(c-regra,"&&","&").

  assign i-inicio = 1
         i-tam    = length(c-regra).
  repeat:
    assign i-fim = i-inicio + 1.
    if i-fim > i-tam then leave.
    i-fim = index(c-regra,"&",i-fim).
    c-var-comp = trim(substr(c-regra, i-inicio + 1, (i-fim - i-inicio - 1))).
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
                  apply "ENTRY" to c-regra-exist  in frame {&frame-name}.
                  return "ADM-ERROR":U.                   
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


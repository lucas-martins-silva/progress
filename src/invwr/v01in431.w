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
{include/i-prgvrs.i V01IN431 2.00.00.024}  /*** "010024" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN431 MUT}
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

/* Local Variable Definitions ---                                       */

def var c-arqtexto as char no-undo.

def new global shared var gr-item as rowid no-undo. 

define var v-row-parent as rowid no-undo.
define var rw-item      as rowid no-undo.
def var c-aux        as char format "x(200)" no-undo.
def var l-permis     as log         no-undo.
def var c-usuario    as char format "x(200)" no-undo.

define buffer b-texto for texto.


/**************************** MULTIPLANTA *******************************/
def var l-cria as logical no-undo.
{cdp/cd7300.i1}
{cdp/cdapi225.i}
/***************************FIM  MULTIPLANTA ****************************/

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
&Scoped-define EXTERNAL-TABLES texto
&Scoped-define FIRST-EXTERNAL-TABLE texto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR texto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS texto.data-implant texto.responsavel ~
texto.narrativa-texto 
&Scoped-define ENABLED-TABLES texto
&Scoped-define FIRST-ENABLED-TABLE texto
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold bt-arquivo 
&Scoped-Define DISPLAYED-FIELDS texto.it-codigo item.desc-item texto.tipo ~
texto.data-implant texto.responsavel texto.narrativa-texto 
&Scoped-define DISPLAYED-TABLES item texto
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-define SECOND-DISPLAYED-TABLE texto
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-arquivo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS texto.it-codigo texto.tipo 

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
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\gr-ger":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 8.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     texto.it-codigo AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item.desc-item AT ROW 1.17 COL 39.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     texto.tipo AT ROW 2.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     c-descricao AT ROW 2.17 COL 31 COLON-ALIGNED NO-LABEL
     texto.data-implant AT ROW 3.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     texto.responsavel AT ROW 4.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     bt-arquivo AT ROW 5.71 COL 59.14
     c-arquivo AT ROW 5.75 COL 22 COLON-ALIGNED
     texto.narrativa-texto AT ROW 6.75 COL 4 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 15000 SCROLLBAR-VERTICAL
          SIZE 80 BY 5
          FONT 2
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.texto
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
         HEIGHT             = 11.13
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

/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN texto.tipo IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo V-table-Win
ON CHOOSE OF bt-arquivo IN FRAME f-main
DO:
  os-command no-wait 'start ' value (chr(34) + input frame {&frame-name} c-arquivo + chr(34)).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME texto.tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL texto.tipo V-table-Win
ON F5 OF texto.tipo IN FRAME f-main /* Tipo Texto */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z01in437.w"
                      &campo=texto.tipo 
                      &campozoom=tipo   
                      &campo2=c-descricao
                      &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL texto.tipo V-table-Win
ON LEAVE OF texto.tipo IN FRAME f-main /* Tipo Texto */
DO:
  {include/leave.i &tabela=tipo-texto
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao
                   &where="tipo-texto.tipo = input frame {&frame-name} texto.tipo"}
                   
  find tipo-texto where tipo-texto.tipo = input frame {&frame-name} texto.tipo no-lock no-error.
  if not avail tipo-texto then do:
     {utp/ut-table.i mgind tipo-texto 1}
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL texto.tipo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF texto.tipo IN FRAME f-main /* Tipo Texto */
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
  
  if texto.tipo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.


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
  {src/adm/template/row-list.i "texto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "texto"}

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
  find item where rowid(item) = rw-item no-lock no-error.
   
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  display today @ texto.data-implant with frame {&frame-name}.

  find item where rowid(item) = gr-item no-lock no-error.
  if avail item then 
     display item.it-codigo @ texto.it-codigo 
             item.desc-item with frame {&frame-name}.
 
  
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
  if texto.tipo:sensitive in frame {&frame-name} = yes then do:
      if can-find(b-texto where b-texto.tipo = input frame {&frame-name} texto.tipo
         and      b-texto.it-codigo = item.it-codigo) then do:
        {utp/ut-table.i mgind texto 1}
        run utp/ut-msgs.p (input 'show',
                           input 1,
                           input return-value).
        apply 'entry' to texto.tipo in frame {&frame-name}.      
        return 'ADM-ERROR':U.
      end.
      find tipo-texto where tipo-texto.tipo = input frame {&frame-name} texto.tipo no-lock no-error.
      run utp/ut-vlusr.p (input tipo-texto.permis-atual,
                          input no).
  end.

  /* Valida‡Æo da data de implanta‡Æo */
  
  if adm-new-record = yes then do:
     if input frame {&frame-name} texto.data-implant < today then do:
        run utp/ut-msgs.p (input "show",
                           input 7487,
                           input return-value).   
        apply 'entry' to texto.data-implant in frame {&frame-name}.
        return 'adm-error':U.                    
     end.   
  end.      
  else do:
     if texto.data-implant < today and
        input frame {&frame-name} texto.data-implant < texto.data-implant then do:       
        run utp/ut-msgs.p (input "show",
                           input 7490,
                           input return-value).   
        apply 'entry' to texto.data-implant in frame {&frame-name}.
        return 'adm-error':U.                    
     end.                      
     else do:
          if texto.data-implant >= today and
             input frame {&frame-name} texto.data-implant < today  then do:
             run utp/ut-msgs.p (input "show",
                                input 7487,
                                input return-value).      
             apply 'entry' to texto.data-implant in frame {&frame-name}.
             return 'adm-error':U.                    
          end.   
     end.        
  end.

  
  /* Ponha aqui as demais valida‡äes */
  
  /** verifica na inclusao do tipo de texto a permissao de inclusao do usuario.**/
 
  find tipo-texto where tipo-texto.tipo = input frame {&frame-name} texto.tipo no-lock no-error.
  if not avail tipo-texto then do:
         {utp/ut-table.i mgind tipo-texto 1}
         run utp/ut-msgs.p (input "show",
                            input 56,
                            input return-value).
         apply 'entry' to input frame {&frame-name} texto.tipo.
         return error.
  end.
       
  if avail tipo-texto then 
     run utp/ut-vlusr.p (input tipo-texto.permis-atual,
                              input no).
  if tipo-texto.permis-atual <> '*' and return-value = "no":U then do:
     assign c-aux = tipo-texto.permis-atual
     l-permis = no.
     repeat:
       if index(c-aux,",") <> 0 then do:
          assign c-usuario = substr(c-aux,1,index(c-aux,",") - 1).
              if c-usuario = c-seg-usuario OR C-SEG-USUARIO = C-USUARIO then do:
                 assign l-permis = yes.
                 leave.
              end.
              else assign c-aux = substr(c-aux,index(c-aux,",") + 1).
       end.
       else do:
          if c-aux = c-seg-usuario then 
             assign l-permis = yes.
             leave.
       end.
     end.
     if l-permis = no then do:  
        {utp/ut-table.i mgind tipo-texto 1}
        run utp/ut-msgs.p (input 'show',
                           input 1514,
                           input return-value).
                               
        return error.
     end.
  end.
  
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                            */


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  IF RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
    
/****************************MULTIPLANTA***************************/
  assign c-transacao = "MAN008".
 
  {cdp/cd7300.i5 "001" c-transacao}
 
  if  param-global.modulo-mp and
      tt-replica-msg.log-replica-msg  = yes then do: 
      create tt-texto-aux.
      buffer-copy texto to tt-texto-aux.
      create tt-dados-env.                  
      assign tt-dados-env.num-sequencia  = i-seq 
             tt-dados-env.cod-tipo-reg   = 52
             tt-dados-env.ind-tipo-movto = if l-cria then 1 else 2
             tt-dados-env.identif-msg    = texto.tipo + "  " + texto.it-codigo.
      raw-transfer tt-texto-aux to tt-dados-env.conteudo-msg.                                     
      assign i-seq = i-seq + 1.                                     
     
      find tipo-texto of texto no-lock.
      create tt-tipo-texto-aux.
      buffer-copy tipo-texto to tt-tipo-texto-aux.
      create tt-dados-env.                  
      assign tt-dados-env.num-sequencia  = i-seq 
             tt-dados-env.cod-tipo-reg   = 153
             tt-dados-env.ind-tipo-movto = 8
             tt-dados-env.identif-msg    = texto.tipo.
      raw-transfer tt-tipo-texto-aux to tt-dados-env.conteudo-msg.                                     
      assign i-seq = i-seq + 1.                                     
  end.
  
  {cdp/cd7300.i6 "001" c-transacao} 

/***************************FIM MULTIPLANTA*************************/


  /* Code placed here will execute AFTER standard behavior.    */

  /*** Verifica e atualiza o nome do arquivo de texto ***/
  
  if avail texto and c-arquivo:visible = yes then
     assign texto.char-2 = c-arquivo:screen-value.
  
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
  assign l-cria          = yes.
       
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
  
  find item where rowid(item) = gr-item no-lock no-error.
  if avail item then 
     display item.it-codigo @ texto.it-codigo
             item.desc-item with frame {&frame-name}.
             
  if available texto then do:
     find tipo-texto of texto no-lock no-error.
     assign c-descricao = if avail tipo-texto then tipo-texto.descricao 
                          else "":U.
  end.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   if  avail texto and texto.char-2 <> "" then do:
      {utp/ut-liter.i Arquivo * R }
      assign c-arquivo:label in frame {&frame-name} = return-value
             c-arquivo:visible      in frame {&frame-name} = yes
             c-arquivo:sensitive    in frame {&frame-name} = yes
             bt-arquivo:visible     in frame {&frame-name} = yes
             c-arquivo:screen-value in frame {&frame-name} = texto.char-2
             c-arquivo = texto.char-2.
             
   end.
   else
      assign c-arquivo:visible      in frame {&frame-name} = no
             bt-arquivo:visible     in frame {&frame-name} = no.
    
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
  
  DISABLE texto.it-codigo WITH FRAME {&frame-name}.
  
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
             
   if  avail texto and texto.char-2 <> "" then do:
      {utp/ut-liter.i Arquivo * R }
      assign c-arquivo:label in frame {&frame-name} = return-value
             c-arquivo:visible      in frame {&frame-name} = yes
             c-arquivo:sensitive    in frame {&frame-name} = yes
             bt-arquivo:visible     in frame {&frame-name} = yes
             c-arquivo:screen-value in frame {&frame-name} = texto.char-2
             c-arquivo = texto.char-2.    
   end.
   else
      assign c-arquivo:visible      in frame {&frame-name} = no
             bt-arquivo:visible     in frame {&frame-name} = no.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-var V-table-Win 
PROCEDURE pi-inicializa-var :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter v-row-table as rowid no-undo.

assign v-row-parent = v-row-table.


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
  {src/adm/template/snd-list.i "texto"}

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


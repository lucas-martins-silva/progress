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
{include/i-prgvrs.i V04IN464 2.00.01.015 } /*** "010115" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v04in464 MUT}
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
                             
def new global shared var gr-modelo-cf  as rowid no-undo.
def new global shared var gr-item       as rowid no-undo.
def new global shared var gr-rot-fabric as rowid no-undo.
def new global shared var r-parent      as rowid no-undo.
def new global shared var gr-operacao   as rowid no-undo.

{cdp/cdcfgman.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-estado     as char.
def var c-handle     as char   no-undo.
def var h-handle     as handle no-undo.
def var h-handle-1   as handle no-undo.
def var c-it-codigo  like item.it-codigo.
def var c-fm-codigo  like item.fm-codigo.
def var c-modelo     like modelo-cf.mo-codigo.
def var c-it-modelo  like modelo-cf.item-criado.

DEFINE VARIABLE c-it-codigo-aux like modelo-cf.item-criado NO-UNDO.

def var r-rot-fabric as rowid no-undo.

def buffer b1-estr-mod-cf for estr-mod-cf.
def buffer b-modelo-cf for modelo-cf.
def buffer b1-modelo-cf for modelo-cf.

def var rw-parent    as rowid   no-undo.
def var i-compara    as integer no-undo.
def var de-compara   as dec     no-undo.
def var l-leave      as log     init no no-undo.
def var de-quant     like estr-mod-cf.quant-usada.
def var de-aux       as decimal.

def var h_v05in464 as handle no-undo.

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
&Scoped-Define ENABLED-FIELDS estr-mod-cf.cod-roteiro estr-mod-cf.op-codigo ~
estr-mod-cf.local-montag estr-mod-cf.fator-perda estr-mod-cf.proporcao ~
estr-mod-cf.tempo-reserv estr-mod-cf.nome-var estr-mod-cf.log-quant-fix
&Scoped-define ENABLED-TABLES estr-mod-cf
&Scoped-define FIRST-ENABLED-TABLE estr-mod-cf
&Scoped-Define ENABLED-OBJECTS RECT-3 fi-qtd-componente fi-qtd-refer-item 
&Scoped-Define DISPLAYED-FIELDS estr-mod-cf.cod-roteiro ~
estr-mod-cf.op-codigo estr-mod-cf.local-montag estr-mod-cf.fator-perda ~
estr-mod-cf.proporcao estr-mod-cf.quant-usada estr-mod-cf.tempo-reserv ~
estr-mod-cf.nome-var estr-mod-cf.log-quant-fix
&Scoped-define DISPLAYED-TABLES estr-mod-cf
&Scoped-define FIRST-DISPLAYED-TABLE estr-mod-cf
&Scoped-Define DISPLAYED-OBJECTS fi-descricao-rb fi-descricao-op ~
fi-qtd-componente fi-qtd-refer-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS estr-mod-cf.quant-usada fi-qtd-componente ~
fi-qtd-refer-item 

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
DEFINE VARIABLE fi-descricao-op AS CHARACTER FORMAT "x(34)" 
     VIEW-AS FILL-IN 
     SIZE 35.43 BY .88.

DEFINE VARIABLE fi-descricao-rb AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88.

DEFINE VARIABLE fi-qtd-componente AS DECIMAL FORMAT ">>>,>>9.999999":U INITIAL 0 
     LABEL "Qtd Componente" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-refer-item AS DECIMAL FORMAT ">>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Refer Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 7.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estr-mod-cf.cod-roteiro AT ROW 1.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-descricao-rb AT ROW 1.25 COL 37 COLON-ALIGNED NO-LABEL
     estr-mod-cf.op-codigo AT ROW 2.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-descricao-op AT ROW 2.25 COL 27 COLON-ALIGNED NO-LABEL
     estr-mod-cf.local-montag AT ROW 3.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 56.43 BY .88
     estr-mod-cf.fator-perda AT ROW 4.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estr-mod-cf.proporcao AT ROW 4.25 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     estr-mod-cf.quant-usada AT ROW 5.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     estr-mod-cf.tempo-reserv AT ROW 5.25 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-qtd-componente AT ROW 6.25 COL 19 COLON-ALIGNED
     estr-mod-cf.nome-var AT ROW 6.25 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     fi-qtd-refer-item AT ROW 7.25 COL 19 COLON-ALIGNED
     estr-mod-cf.log-quant-fix AT ROW 7.25 COL 54 COLON-ALIGNED
          VIEW-AS TOGGLE-BOX
          SIZE 17.72 BY .88
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
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
         HEIGHT             = 7.63
         WIDTH              = 84.29.
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao-op IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao-rb IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qtd-componente IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-qtd-refer-item IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN estr-mod-cf.quant-usada IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME estr-mod-cf.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.cod-roteiro V-table-Win
ON F5 OF estr-mod-cf.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  find item where item.it-codigo = b-modelo-cf.item-criado no-lock no-error.     
  if avail item then
  assign gr-item     = rowid(item)
  c-it-codigo = b-modelo-cf.item-criado.  
  
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in400.w"
                     &campo=estr-mod-cf.cod-roteiro
                     &campozoom=cod-roteiro
                     &campo2=fi-descricao-rb
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                     (input c-it-codigo)."}                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.cod-roteiro V-table-Win
ON LEAVE OF estr-mod-cf.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
 if input frame {&frame-name} estr-mod-cf.cod-roteiro <> "" then do:
   find rot-fabric where rot-fabric.cod-roteiro = input frame {&frame-name} 
        estr-mod-cf.cod-roteiro no-lock no-error.
   if avail rot-fabric then do:  
      find rot-item
           where rot-item.it-codigo = b-modelo-cf.item-criado 
           and rot-item.cod-roteiro = input frame {&frame-name} estr-mod-cf.cod-roteiro
           no-lock no-error.
      if avail rot-item then do:
               assign fi-descricao-rb = rot-fabric.descricao.
               disp fi-descricao-rb with frame {&frame-name}.
      end.         
      else do:
              run utp/ut-msgs.p (input "show",
                                 input 2688,
                                 input "").      
              fi-descricao-rb:screen-value in frame {&frame-name} = rot-fabric.descricao.
              apply "ENTRY" to estr-mod-cf.cod-roteiro in frame {&frame-name}.
              return no-apply. 
      end.   
   end. 
   else  do: 
        {utp/ut-field.i mgind rot-fabric cod-roteiro 1}.
        run utp/ut-msgs.p (input "show",
                                 input 56,
                                 input return-value). 
        assign fi-descricao-rb:screen-value in frame {&frame-name} = "".
        apply "ENTRY" to estr-mod-cf.cod-roteiro in frame {&frame-name}.
        return no-apply.         
   end     .
 end.  
 else fi-descricao-rb:screen-value in frame {&frame-name} = "".             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qtd-componente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-componente V-table-Win
ON LEAVE OF fi-qtd-componente IN FRAME f-main /* Qtd Componente */
DO:
  if valid-handle(h_v05in464) then
    run pi-atualiza-compon in h_v05in464 (input fi-qtd-componente:screen-value in frame {&frame-name},
                                          input estr-mod-cf.log-quant-fix:checked in frame {&frame-name}).
  
  &IF DEFINED (bf_man_204) &THEN
    if fi-qtd-componente:screen-value in frame {&frame-name} = ? then
        estr-mod-cf.quant-usada:screen-value in frame {&frame-name} = ?.
    else 
        if dec(fi-qtd-refer-item:screen-value in frame {&frame-name}) <> 0 then do:
            assign de-aux = dec(fi-qtd-componente:screen-value in frame {&frame-name}) / dec(fi-qtd-refer-item:screen-value in frame {&frame-name}).
            estr-mod-cf.quant-usada:screen-value in frame {&frame-name} = string(de-aux).
    end.      

  /***************************************************************/
    &IF DEFINED (bf_man_preco_config) &THEN
    &ELSE
      run get-link-handle in adm-broker-hdl (input this-procedure,
                                             input "state-target",
                                             output c-handle).

      assign h-handle = widget-handle(entry(1,c-handle))
             h-handle-1 = widget-handle(entry(2,c-handle)).

      /*ksm42618*/
      if INPUT FRAME {&frame-name} fi-qtd-componente <> ? THEN 
          RUN pi-limpa-formula IN h-handle-1.
      /*ksm42618*/                                             

      if  input frame {&frame-name} estr-mod-cf.quant-usada <> ? then do:
          if  input frame {&frame-name} estr-mod-cf.quant-usada < 0.09 then 
              run pi-atu-quantidades in h-handle (input 0,
                                                  input 0.1,
                                                  input frame {&frame-name}
                                                  estr-mod-cf.quant-usada).        
          else
              run pi-atu-quantidades in h-handle (input frame {&frame-name} 
                                                  estr-mod-cf.quant-usada,
                                                  input frame {&frame-name} 
                                                  estr-mod-cf.quant-usada,
                                                  input frame {&frame-name}
                                                  estr-mod-cf.quant-usada).     
      end.                                                 
      else do:
           run pi-atu-quantidades in h-handle (input 0,
                                               input 999999,
                                               input frame {&frame-name}
                                               estr-mod-cf.quant-usada).       
      end.
          
      assign l-leave = yes.   
               
      run get-link-handle in adm-broker-hdl (input this-procedure,
                                             input "state-target",
                                             output c-handle).
       
      assign h-handle = widget-handle(entry(2,c-handle)).
        
      if  input frame {&frame-name} estr-mod-cf.quant-usada = ? then
          run pi-atualiza-formula in h-handle (input yes).        
      else
          run pi-atualiza-formula in h-handle (input no).
    &ENDIF
  &ENDIF 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qtd-refer-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-refer-item V-table-Win
ON LEAVE OF fi-qtd-refer-item IN FRAME f-main /* Qtd Refer Item */
DO:

  &IF DEFINED (bf_man_204) &THEN
    def var de-aux2  as decimal.
    
    if fi-qtd-componente:screen-value in frame {&frame-name} <> ? and dec(fi-qtd-refer-item:screen-value in frame {&frame-name}) <> 0 then do:
        assign de-aux2 = dec(fi-qtd-componente:screen-value in frame {&frame-name}) / dec(fi-qtd-refer-item:screen-value in frame {&frame-name}).
        estr-mod-cf.quant-usada:screen-value in frame {&frame-name} = string(de-aux2).
    end.
    else if dec(fi-qtd-refer-item:screen-value in frame {&frame-name}) = 0 then do:
        run utp/ut-msgs.p (input "show",
                     input 1368,
                     input "").
        assign fi-qtd-refer-item:screen-value in frame {&frame-name} = string(de-aux).
        return no-apply.    
    end.
   apply 'leave' to fi-qtd-componente.
  &ENDIF   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.nome-var
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.nome-var V-table-Win
ON F5 OF estr-mod-cf.nome-var IN FRAME f-main /* Vari†vel */
DO:
&IF DEFINED (bf_man_204) &THEN
   assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=mfzoom/z01mf450.w
                  &campo=estr-mod-cf.nome-var
                  &campozoom=nome-var}
   assign l-implanta = no.  
&ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param h_browse as handle.

assign h_v05in464 = h_browse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.log-quant-fix
/* D_MAN002 - Quantidade fixa para componentes de engenharia */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.log-quant-fix V-table-Win
ON VALUE-CHANGED OF estr-mod-cf.log-quant-fix IN FRAME f-main 
DO:
    if  estr-mod-cf.log-quant-fix:checked in frame {&frame-name} = YES THEN DO:
        assign  estr-mod-cf.proporcao:SENSITIVE = FALSE
                estr-mod-cf.proporcao:SCREEN-VALUE = "100"
                estr-mod-cf.fator-perda:SENSITIVE = FALSE
                estr-mod-cf.fator-perda:SCREEN-VALUE = "0"
                fi-qtd-refer-item:SENSITIVE IN FRAME {&frame-name} = FALSE
                fi-qtd-refer-item:SCREEN-VALUE IN FRAME {&frame-name} = "1".
    
        if valid-handle(h_v05in464) then
            run pi-atualiza-compon in h_v05in464 (input fi-qtd-componente:screen-value in frame {&frame-name},
                                                  input estr-mod-cf.log-quant-fix:checked in frame {&frame-name}).
    
    END.
    ELSE DO:
        assign  estr-mod-cf.proporcao:SENSITIVE = TRUE
                estr-mod-cf.proporcao:SCREEN-VALUE = "100"
                estr-mod-cf.fator-perda:SENSITIVE = TRUE
                estr-mod-cf.fator-perda:SCREEN-VALUE = "0"
                fi-qtd-refer-item:SENSITIVE IN FRAME {&frame-name} = TRUE.
        
        if valid-handle(h_v05in464) then
            run pi-atualiza-compon in h_v05in464 (input fi-qtd-componente:screen-value in frame {&frame-name},
                                                  input estr-mod-cf.log-quant-fix:checked in frame {&frame-name}).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.nome-var V-table-Win
ON LEAVE OF estr-mod-cf.nome-var IN FRAME f-main /* Vari†vel */
DO:

&IF DEFINED (bf_man_204) &THEN
  if can-find (first var-modelo where 
               var-modelo.mo-codigo = c-modelo and
               var-modelo.nome-var  = estr-mod-cf.nome-var:screen-value in frame {&frame-name} no-lock)
               then do:
    run utp/ut-msgs.p (input "show",
                       input 25361,
                       input "").
    apply "ENTRY" to estr-mod-cf.nome-var in frame {&frame-name}.
    return no-apply. 
  end.
&ENDIF
  
                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.nome-var V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.nome-var IN FRAME f-main /* Vari†vel */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.op-codigo V-table-Win
ON F5 OF estr-mod-cf.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
  find rot-fabric 
       where rot-fabric.cod-roteiro = input frame {&frame-name} estr-mod-cf.cod-roteiro 
       no-lock no-error.
  if avail rot-fabric then do: 
     assign gr-rot-fabric = rowid(rot-fabric)
            gr-item       = ?.
            rw-parent     = gr-rot-fabric.
  end.          
  else do: 
    find b-modelo-cf where rowid(b-modelo-cf) = r-parent no-lock no-error.
    find item where item.it-codigo = b-modelo-cf.item-criado no-lock no-error.     
    if avail item then do: 
        assign gr-item       = rowid(item)
               gr-rot-fabric = ?
               rw-parent     = gr-item.
    end.               
  end.   

  assign l-implanta  = yes
         gr-operacao = ?.

 {include/zoomvar.i &prog-zoom="inzoom/z04in263.w"
                    &campo=estr-mod-cf.op-codigo
                    &campozoom=op-codigo
                    &campo2=fi-descricao-op
                    &campozoom2=descricao
                    &parametros="run pi-seta-inicial in wh-pesquisa 
                    (input rw-parent)."}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.op-codigo V-table-Win
ON LEAVE OF estr-mod-cf.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
 if input frame {&frame-name} estr-mod-cf.cod-roteiro <> "" then do:
    find first operacao
         where operacao.cod-roteiro = input frame {&frame-name} estr-mod-cf.cod-roteiro
           and operacao.op-codigo   = input frame {&frame-name} estr-mod-cf.op-codigo no-lock no-error. 
    if avail operacao then do:
       assign fi-descricao-op = operacao.descricao.
       disp fi-descricao-op with frame {&frame-name}.
    end.
    else do: 
       {utp/ut-field.i mgind operacao op-codigo 1}.
        run utp/ut-msgs.p (input "show",
                                 input 56,
                                 input return-value). 
       fi-descricao-op = "".
       disp fi-descricao-op with frame {&frame-name}.
       apply "ENTRY" to estr-mod-cf.cod-roteiro in frame {&frame-name}.
       return no-apply.         
    end.
 end.                        
 else do:
   if  input frame {&frame-name} estr-mod-cf.op-codigo <> 0 then do:
       find b-modelo-cf where rowid(b-modelo-cf) = r-parent no-lock no-error.     
       assign c-it-codigo = b-modelo-cf.item-criado.
       find first operacao 
            where operacao.it-codigo   = c-it-codigo
              and operacao.op-codigo   = input frame {&frame-name} estr-mod-cf.op-codigo no-lock no-error.
       if avail operacao then do:
          assign fi-descricao-op = operacao.descricao.
          disp fi-descricao-op with frame {&frame-name}.
       end.     
       else do: 
           {utp/ut-field.i mgind operacao op-codigo 1}
            run utp/ut-msgs.p (input "show",
                                     input 56,
                                     input return-value). 
           fi-descricao-op = "".
           disp fi-descricao-op with frame {&frame-name}.
           return no-apply.  
       end.                                             
   end.
 end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.quant-usada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.quant-usada V-table-Win
ON LEAVE OF estr-mod-cf.quant-usada IN FRAME f-main /* Qtde */
DO:
  &IF DEFINED (bf_man_204) &THEN
  &ELSE
    run get-link-handle in adm-broker-hdl (input this-procedure,
                                           input "state-target",
                                           output c-handle).
   
    assign h-handle = widget-handle(entry(1,c-handle)).
    
    if  input frame {&frame-name} estr-mod-cf.quant-usada <> ? then do:
        if  input frame {&frame-name} estr-mod-cf.quant-usada < 0.09 then 
            run pi-atu-quantidades in h-handle (input 0,
                                                input 0.1,
                                                input frame {&frame-name}
                                                estr-mod-cf.quant-usada).        
        else
            run pi-atu-quantidades in h-handle (input frame {&frame-name} 
                                                estr-mod-cf.quant-usada,
                                                input frame {&frame-name} 
                                                estr-mod-cf.quant-usada,
                                                input frame {&frame-name}
                                                estr-mod-cf.quant-usada).     
    end.                                                 
    else do:
         run pi-atu-quantidades in h-handle (input 0,
                                             input 999999,
                                             input frame {&frame-name}
                                             estr-mod-cf.quant-usada).       
    end.
       
    assign l-leave = yes.   
             
    run get-link-handle in adm-broker-hdl (input this-procedure,
                                           input "state-target",
                                           output c-handle).
    
    assign h-handle = widget-handle(entry(2,c-handle)).
    
    if  input frame {&frame-name} estr-mod-cf.quant-usada = ? then
        run pi-atualiza-formula in h-handle (input yes).        
    else
        run pi-atualiza-formula in h-handle (input no).
  &ENDIF 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  if estr-mod-cf.cod-roteiro:load-mouse-pointer ("image/lupa.cur")
     in frame {&frame-name} then .
  if estr-mod-cf.op-codigo:load-mouse-pointer ("image/lupa.cur")
     in frame {&frame-name} then .

&IF DEFINED (bf_man_204) &THEN
  if estr-mod-cf.nome-var:load-mouse-pointer ("image/lupa.cur")
     in frame {&frame-name} then .
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

  assign estr-mod-cf.quant-usada:screen-value in frame {&frame-name} = string(0)
         fi-qtd-componente:screen-value in frame {&frame-name} = string(0)
         fi-qtd-refer-item:screen-value in frame {&frame-name} = string(1)
         estr-mod-cf.tempo-reserv:screen-value in frame {&frame-name} = "?".
  
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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  
  run pi-validate.
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  &IF DEFINED (bf_man_204) &THEN
    assign estr-mod-cf.qtd-compon = dec(fi-qtd-componente:screen-value in frame {&frame-name})
           estr-mod-cf.qtd-item   = dec(fi-qtd-refer-item:screen-value in frame {&frame-name}).
  &ENDIF    

if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
   
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
       
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "it-codigo").

  assign c-it-codigo = return-value.

  if input frame {&frame-name} estr-mod-cf.cod-roteiro <> "" then do:
     find rot-fabric where rot-fabric.cod-roteiro = input frame {&frame-name} 
     estr-mod-cf.cod-roteiro no-lock no-error.
     if avail rot-fabric then do:
        assign fi-descricao-rb = rot-fabric.descricao.
        disp fi-descricao-rb with frame {&frame-name}.
     end.
  end.
  
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                 INPUT "it-codigo").
      
  assign c-it-codigo = return-value.

  if input frame {&frame-name} estr-mod-cf.op-codigo <> 0 then do:
     find first operacao where operacao.op-codigo   = input frame {&frame-name} 
                                                      estr-mod-cf.op-codigo 
                           and operacao.it-codigo   = c-it-codigo 
                           no-lock no-error.
     if avail operacao then do:
        assign fi-descricao-op = operacao.descricao.
     end.
     else do:
        find FIRST b-modelo-cf where
            rowid(b-modelo-cf) = r-parent no-lock no-error.
        IF AVAIL b-modelo-cf THEN
            assign c-it-codigo-aux = b-modelo-cf.item-criado.

        IF input frame {&frame-name} estr-mod-cf.cod-roteiro = "" THEN
            find first operacao WHERE
                operacao.op-codigo = input frame {&frame-name} estr-mod-cf.op-codigo and
                operacao.it-codigo = c-it-codigo-aux no-lock no-error.
        ELSE
            find first operacao WHERE
                operacao.op-codigo   = input frame {&frame-name} estr-mod-cf.op-codigo and
                operacao.cod-roteiro = input frame {&frame-name} estr-mod-cf.cod-roteiro no-lock no-error.

        if avail operacao then do:
           assign fi-descricao-op = operacao.descricao.
        end.
        else do:
           assign fi-descricao-op = "".
        end.
     end.
  end.

  disp fi-descricao-op 
       fi-descricao-rb with frame {&frame-name}.

  &IF DEFINED (bf_man_204) &THEN
    if avail estr-mod-cf 
    then do:
       if adm-new-record = no
       then do:
          assign fi-qtd-componente:screen-value in frame {&frame-name} = string(estr-mod-cf.qtd-compon)
                 fi-qtd-refer-item:screen-value in frame {&frame-name} = string(estr-mod-cf.qtd-item).
       end.
    end.
  &ENDIF 

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
  
    find b-modelo-cf where rowid(b-modelo-cf) = r-parent no-lock no-error.     
    IF AVAIL estr-mod-cf  THEN
    IF  estr-mod-cf.log-quant-fix = YES and adm-new-record = false THEN DO:
        assign  estr-mod-cf.proporcao:SENSITIVE IN FRAME {&frame-name} = FALSE
                estr-mod-cf.fator-perda:SENSITIVE IN FRAME {&frame-name} = FALSE
                fi-qtd-refer-item:SENSITIVE IN FRAME {&frame-name} = FALSE.

    end.
    else do: 
        assign  estr-mod-cf.proporcao:SENSITIVE IN FRAME {&frame-name} = TRUE
                estr-mod-cf.fator-perda:SENSITIVE IN FRAME {&frame-name} = TRUE
                fi-qtd-refer-item:SENSITIVE IN FRAME {&frame-name} = TRUE.
    end.

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
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  find b1-modelo-cf where rowid(b1-modelo-cf) = gr-modelo-cf no-lock no-error.
  if avail b1-modelo-cf then assign c-modelo = b1-modelo-cf.mo-codigo.

  &IF DEFINED (bf_man_204) &THEN
  &ELSE
    hide fi-qtd-componente in frame {&frame-name}.
    hide fi-qtd-refer-item in frame {&frame-name}.
    enable estr-mod-cf.quant-usada with frame {&frame-name}.
  &ENDIF 
                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estado V-table-Win 
PROCEDURE pi-atualiza-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-estado as char.

assign c-estado = p-estado.

run get-link-handle in adm-broker-hdl (input this-procedure,
                                       input "state-target",
                                       output c-handle).
 
assign h-handle = widget-handle(entry(1,c-handle)).

if  input frame {&frame-name} estr-mod-cf.quant-usada <> ? then do:
    if  input frame {&frame-name} estr-mod-cf.quant-usada < 0.09 then 
        run pi-atu-quantidades in h-handle (input 0,
                                            input 0.1,
                                            input frame {&frame-name}
                                            estr-mod-cf.quant-usada).        
    else
        run pi-atu-quantidades in h-handle (input frame {&frame-name} 
                                            estr-mod-cf.quant-usada,
                                            input frame {&frame-name} 
                                            estr-mod-cf.quant-usada,
                                            input frame {&frame-name}
                                            estr-mod-cf.quant-usada).     
end.                                                 
else do:
    run pi-atu-quantidades in h-handle (input 0,
                                        input 999999,
                                        input frame {&frame-name}
                                        estr-mod-cf.quant-usada).       
end.

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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

 def var c-liter-e   as char format "x(03)" no-undo.
 def var c-liter-ou  as char format "x(03)" no-undo.
 def var c-liter-cte as char format "x(10)" no-undo.
 def var c-liter-op  as char format "x(16)" no-undo.
   
  assign de-quant = input frame {&frame-name} estr-mod-cf.quant-usada.
  if de-quant = 0 then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show", input 16771, input "").
      apply 'entry' to estr-mod-cf.quant-usada in frame {&frame-name}.
      return "ADM-ERROR".  
  end. 
   
 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").
 
  assign c-it-codigo = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT THIS-PROCEDURE,
      INPUT "fm-codigo").

   assign c-fm-codigo = return-value.

  IF  NOT CAN-FIND(FIRST funcao NO-LOCK WHERE funcao.cd-funcao = "spp-formula-familia" AND funcao.ativo = YES)
  AND c-fm-codigo <> ""
  AND de-quant = ?
  THEN DO:
      run utp/ut-msgs.p (input "show", 
                         input 25997, 
                         input "Valor da quantidade n∆o pode ser '?'~~Valor da quantidade inv†lida quando selecionado estrutura por familia: " + c-fm-codigo).
      apply 'entry' to estr-mod-cf.quant-usada in frame {&frame-name}.
      return "ADM-ERROR".  
  END.

  run get-link-handle in adm-broker-hdl (input this-procedure,
                                         input "state-target",
                                         output c-handle).
 
  assign h-handle = widget-handle(entry(1,c-handle)).
 
 if l-leave = no then do:
     run get-link-handle in adm-broker-hdl (input this-procedure,
                                         input "state-target",
                                         output c-handle).
 
     assign h-handle = widget-handle(entry(1,c-handle)).
     run pi-atu-quantidades in h-handle (?,
                                         ?,
                                         input frame {&frame-name}
                                         estr-mod-cf.quant-usada).   
 end.
      
 find b1-modelo-cf where rowid(b1-modelo-cf) = r-parent no-lock no-error.
 
 assign c-it-modelo = if avail b1-modelo-cf then b1-modelo-cf.item-criado else ""
        i-compara = dec(estr-mod-cf.quant-usada:screen-value in frame {&frame-name})
        de-compara = dec(estr-mod-cf.quant-usada:screen-value in frame {&frame-name}).  
 
 find item where item.it-codigo = c-it-modelo no-lock no-error.
  
 if input frame {&frame-name} estr-mod-cf.tempo-reserv <> ? then do:
    if input frame {&frame-name} estr-mod-cf.tempo-reserv > item.ressup-fabri then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 1326,
                          input "").     
       apply "ENTRY" to estr-mod-cf.tempo-reserv in frame {&frame-name}.
       return "ADM-ERROR":U. 
    end.
 end.    
 
 if input frame {&frame-name} estr-mod-cf.nome-var <> "" then do:
    if index(input frame {&frame-name} estr-mod-cf.nome-var,"*") <> 0 then do :
      {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 6665,
                          input "*").     
       apply "ENTRY" to estr-mod-cf.nome-var in frame {&frame-name}.
       return "ADM-ERROR":U. 
    end.
    if index(input frame {&frame-name} estr-mod-cf.nome-var,"^") <> 0 then do :
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 6665,
                          input "^").     
       apply "ENTRY" to estr-mod-cf.nome-var in frame {&frame-name}.
       return "ADM-ERROR":U.
    end.
    if index(input frame {&frame-name} estr-mod-cf.nome-var,"/") <> 0 then do :
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 6665,
                          input "/").     
       apply "ENTRY" to estr-mod-cf.nome-var in frame {&frame-name}.
       return "ADM-ERROR":U.
    end.
    if index(input frame {&frame-name} estr-mod-cf.nome-var,"-") <> 0 then do :       
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 6665,
                          input "-").     
       apply "ENTRY" to estr-mod-cf.nome-var in frame {&frame-name}.
       return "ADM-ERROR":U. 
    end.
    if index(input frame {&frame-name} estr-mod-cf.nome-var,"+") <> 0 then do :
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 6665,
                          input "+").     
       apply "ENTRY" to estr-mod-cf.nome-var in frame {&frame-name}.
       return "ADM-ERROR":U.
    end.    
    
                /*** VALIDAÄ«O VALORES = "AND, E, OR, OU" ****/
  
    {utp/ut-liter.i E * r}
    assign c-liter-e = trim(return-value).
    {utp/ut-liter.i OU * r}
    assign c-liter-ou = trim(return-value).
    {utp/ut-liter.i Operador_L¢gico * r}
    assign c-liter-op = trim(return-value).

    {utp/ut-field.i mgind constante nome-cte 1}
    assign c-liter-cte = trim(return-value).
 
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = c-liter-e then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                c-liter-e).
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = c-liter-ou then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                c-liter-ou).
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end. 
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = ">" then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                ">").
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end. 
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = "<" then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                "<").
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end. 
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = "=" then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                "=").
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end. 
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = "<>" then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                "<>").
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end. 
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = "<=" then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                "<=").
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    if trim(input frame {&frame-name} estr-mod-cf.nome-var) = ">=" then do:
       run utp/ut-msgs.p (input "show",
                          input 17031,
                          input c-liter-cte + "~~" + 
                                c-liter-op  + "~~" + 
                                ">=").
       apply "entry" to estr-mod-cf.nome-var in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
 end.

 do with frame {&frame-name}:
     if estr-mod-cf.nome-var:screen-value = "and"       or
        estr-mod-cf.nome-var:screen-value = "or"        or
        estr-mod-cf.nome-var:screen-value = "e"         or
        estr-mod-cf.nome-var:screen-value = "ou"        or
        estr-mod-cf.nome-var:screen-value = "n∆o"       or
        estr-mod-cf.nome-var:screen-value = "not"       or
        estr-mod-cf.nome-var:screen-value = "int"       or
        estr-mod-cf.nome-var:screen-value = "dec"       or
        estr-mod-cf.nome-var:screen-value = "str"       or
        estr-mod-cf.nome-var:screen-value = "abs"       or
        estr-mod-cf.nome-var:screen-value = "sqr"       or
        estr-mod-cf.nome-var:screen-value = "ucase"     or
        estr-mod-cf.nome-var:screen-value = "lcase"     or
        estr-mod-cf.nome-var:screen-value = "len"       or
        estr-mod-cf.nome-var:screen-value = "substring" or
        estr-mod-cf.nome-var:screen-value = "search"    or
        estr-mod-cf.nome-var:screen-value = "replace"   or
        estr-mod-cf.nome-var:screen-value = "round"     or
        estr-mod-cf.nome-var:screen-value = "trunc"     or
        estr-mod-cf.nome-var:screen-value = "fat"       or
        estr-mod-cf.nome-var:screen-value = "pi"        or
        estr-mod-cf.nome-var:screen-value = "ang"       or
        estr-mod-cf.nome-var:screen-value = "rad"       or
        estr-mod-cf.nome-var:screen-value = "sin"       or
        estr-mod-cf.nome-var:screen-value = "cos"       or
        estr-mod-cf.nome-var:screen-value = "tan"       or
        estr-mod-cf.nome-var:screen-value = "sec"       or
        estr-mod-cf.nome-var:screen-value = "cosec"     or
        estr-mod-cf.nome-var:screen-value = "cotan" then do:
            run utp/ut-msgs.p (input "show",
                               input 25259,
                               input estr-mod-cf.nome-var:screen-value).
            return "adm-error".
     end.
end. 


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


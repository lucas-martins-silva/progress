&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V05IN390 2.00.00.079 } /*** "010079" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v05in390 MUT}
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

{cdp/cdcfgman.i} /* Pre-processadores */ 

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.            
def new global shared var i-ordem like oper-ord.nr-ord-produ no-undo.                    
def new global shared var c-it-codigo like saldo-estoq.it-codigo   no-undo.
def new global shared var c-estab     like saldo-estoq.cod-estabel no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cpp/cpapi013.i}
{cpp/cpapi018.i}
{cdp/cd0666.i}

def var de-saldo-incrementa as decimal no-undo.

def new global shared var gr-ord-prod as rowid no-undo.
def buffer b-ord for ord-prod.
def buffer b-reservas for reservas.

def var c-handle as char no-undo.
def var h-handle as handle no-undo.
def var de-quant-atend like reservas.quant-atend no-undo.
def var de-aux like reservas.quant-orig.
DEF VAR c-reservas-aux LIKE reservas.tp-atualiza.
/*def var c-it-codigo as char no-undo.*/
def var h-cpapi013 as handle no-undo.
def var h-cpapi018 as handle no-undo.

  {cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */
  {cpp/cpapi301.i} /* Definiá∆o da temp-table */
  DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai_habilit AS LOGICAL NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES reservas
&Scoped-define FIRST-EXTERNAL-TABLE reservas


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR reservas.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS reservas.cod-localiz reservas.cod-depos ~
reservas.lote-serie 
&Scoped-define ENABLED-TABLES reservas
&Scoped-define FIRST-ENABLED-TABLE reservas
&Scoped-Define ENABLED-OBJECTS fi-per-ppm rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS reservas.it-codigo reservas.cod-refer ~
reservas.item-pai reservas.cod-roteiro reservas.op-codigo ~
reservas.cod-localiz reservas.cod-depos reservas.lote-serie 
&Scoped-define DISPLAYED-TABLES reservas
&Scoped-define FIRST-DISPLAYED-TABLE reservas
&Scoped-Define DISPLAYED-OBJECTS fi-per-ppm tg-veiculo fi-item-descricao ~
fi-referencia-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS reservas.it-codigo reservas.cod-refer ~
reservas.item-pai reservas.cod-roteiro reservas.op-codigo 
&Scoped-define ADM-ASSIGN-FIELDS tg-veiculo reservas.it-codigo ~
reservas.cod-refer reservas.item-pai reservas.cod-roteiro ~
reservas.op-codigo 

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
DEFINE VARIABLE fi-item-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .88.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL ""
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-referencia-descricao AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 5.20.

DEFINE VARIABLE tg-veiculo AS LOGICAL INITIAL no 
     LABEL "Ve°culo / Excipiente" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
    reservas.it-codigo          AT ROW 1.17 COL 14.57   COLON-ALIGNED VIEW-AS FILL-IN  SIZE 17.43   BY .88
    fi-item-descricao           AT ROW 1.17 COL 32.72   COLON-ALIGNED NO-LABEL
    reservas.cod-refer          AT ROW 2.70 COL 14.57   COLON-ALIGNED VIEW-AS FILL-IN  SIZE 17.43   BY .88
    fi-referencia-descricao     AT ROW 2.70 COL 32.72   COLON-ALIGNED HELP "Descricao da Referencia" NO-LABEL
    reservas.item-pai           AT ROW 3.65 COL 14.57   COLON-ALIGNED VIEW-AS FILL-IN  SIZE 17.43   BY .88
    reservas.cod-localiz        AT ROW 3.65 COL 49      COLON-ALIGNED VIEW-AS FILL-IN  SIZE 25      BY .88
    reservas.cod-roteiro        AT ROW 4.60 COL 14.57   COLON-ALIGNED VIEW-AS FILL-IN  SIZE 17.43   BY .88
    reservas.cod-depos          AT ROW 4.60 COL 49      COLON-ALIGNED VIEW-AS FILL-IN  SIZE 7.43    BY .88
    reservas.op-codigo          AT ROW 5.60 COL 14.57   COLON-ALIGNED VIEW-AS FILL-IN  SIZE 7.14    BY .88
     reservas.lote-serie        AT ROW 5.60 COL 49      COLON-ALIGNED VIEW-AS FILL-IN  SIZE 34      BY .88
    tg-veiculo                  AT ROW 6.60 COL 16.45
    fi-per-ppm                  AT ROW 6.60 COL 49      COLON-ALIGNED
    rt-key                      AT ROW 1    COL 1
    rt-mold                     AT ROW 2.50 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.reservas
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
         HEIGHT             = 6.96
         WIDTH              = 85.29.
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

/* SETTINGS FOR FILL-IN reservas.cod-refer IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN reservas.cod-roteiro IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-item-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-referencia-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN reservas.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN reservas.item-pai IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN reservas.op-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR TOGGLE-BOX tg-veiculo IN FRAME f-main
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

&Scoped-define SELF-NAME reservas.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-depos V-table-Win
ON F5 OF reservas.cod-depos IN FRAME f-main /* Dep¢sito */
DO:

  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=reservas.cod-depos
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-depos V-table-Win
ON LEAVE OF reservas.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
/*     FIND FIRST deposito WHERE deposito.cod-depos =                        */
/*           input frame {&frame-name} reservas.cod-depos NO-LOCK NO-ERROR.  */
/*         IF NOT AVAIL deposito THEN DO:                                    */
/*           {utp~/ut-liter.i "Dep¢sito Inexistente!"}                        */
/*            run utp/ut-msgs.p (input "show",                               */
/*                               input 17567,                                */
/*                               input RETURN-VALUE).                        */
/*               apply 'entry' TO reservas.cod-depos in frame {&frame-name}. */
/*               return 'ADM-ERROR':U.                                       */
/*          END.                                                             */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-localiz V-table-Win
ON F5 OF reservas.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom = "inzoom/z01in189.w"
                      &campo     = reservas.cod-localiz
                      &campozoom = cod-localiz   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-refer V-table-Win
ON F5 OF reservas.cod-refer IN FRAME f-main /* Referància */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=reservas.cod-refer
                     &campozoom = cod-refer
                     &parametros= "run pi-seta-inicial in wh-pesquisa
                     (reservas.it-codigo:screen-value)." }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-refer V-table-Win
ON LEAVE OF reservas.cod-refer IN FRAME f-main /* Referància */
DO:
   assign fi-referencia-descricao = "".
   find item where item.it-codigo = reservas.it-codigo:screen-value in frame {&frame-name}
        no-lock no-error.
   if avail item then do:
       IF ITEM.politica = 5 THEN DO:

           FIND cot-est-mast no-lock
               WHERE cot-est-mast.item-cotacao = reservas.it-codigo:screen-value in frame {&frame-name}
                 AND cot-est-mast.nr-estrut    = INT(input frame {&frame-name} reservas.cod-refer)
               NO-ERROR.

           IF AVAIL cot-est-mast THEN 
               assign fi-referencia-descricao = cot-est-mast.descricao
                      fi-referencia-descricao:screen-value in frame {&frame-name} = cot-est-mast.descricao.
       END.
       ELSE DO:
           find ref-item use-index item
                where ref-item.it-codigo = input frame {&frame-name} reservas.it-codigo
                  and ref-item.cod-refer = input frame {&frame-name} reservas.cod-refer
                no-lock no-error.
           if avail ref-item then do:
              find referencia of ref-item no-lock no-error.
              if avail referencia then
                 assign fi-referencia-descricao = referencia.descricao
                        fi-referencia-descricao:screen-value in frame {&frame-name} = referencia.descricao.
           end. 
       END.
   END.
   display fi-referencia-descricao with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.cod-refer IN FRAME f-main /* Referància */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-roteiro V-table-Win
ON F5 OF reservas.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'f5' to reservas.op-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'f5' to reservas.op-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.it-codigo V-table-Win
ON ENTRY OF reservas.it-codigo IN FRAME f-main /* Item Reserva */
DO:
  find item where item.it-codigo = input frame {&frame-name} reservas.it-codigo
       no-lock no-error.
  if avail item then
     assign fi-item-descricao = item.desc-item. 
  else
      assign fi-item-descricao = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.it-codigo V-table-Win
ON F5 OF reservas.it-codigo IN FRAME f-main /* Item Reserva */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=reservas.it-codigo
                     &campozoom=it-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.it-codigo V-table-Win
ON LEAVE OF reservas.it-codigo IN FRAME f-main /* Item Reserva */
DO:
        find item where item.it-codigo = reservas.it-codigo:screen-value in frame {&frame-name}
             no-lock no-error.
        if avail item then do:
           assign fi-item-descricao = item.desc-item
                  fi-item-descricao:screen-value in frame {&frame-name} = item.desc-item.

           /** Habilita campo Referància **/
           if item.tipo-con-est > 1 then
              enable reservas.lote-serie with frame {&frame-name}.
           else     
              disable reservas.lote-serie with frame {&frame-name}.
           /*******************************/

           FIND FIRST item-uni-estab 
               WHERE item-uni-estab.cod-estabel = ord-prod.cod-estabel 
               AND   item-uni-estab.it-codigo   = reservas.it-codigo:screen-value  in frame {&frame-name} NO-LOCK NO-ERROR.
               IF AVAIL item-uni-estab THEN
                   assign reservas.cod-localiz:screen-value  in frame {&frame-name} = item-uni-estab.cod-localiz.
               ELSE
                   assign reservas.cod-localiz:screen-value  in frame {&frame-name} = item.cod-localiz.

           if reservas.cod-depos:screen-value  in frame {&frame-name} = "" then DO:
                   FIND FIRST item-uni-estab 
                       WHERE item-uni-estab.cod-estabel = ord-prod.cod-estabel 
                       AND   item-uni-estab.it-codigo   = reservas.it-codigo:screen-value  in frame {&frame-name} NO-LOCK NO-ERROR.
                       IF AVAIL item-uni-estab THEN 
                           assign reservas.cod-depos:screen-value  in frame {&frame-name}  =  item-uni-estab.deposito-pad.
                       ELSE
                           assign reservas.cod-depos:screen-value  in frame {&frame-name}  = item.deposito-pad.
           END.
           ELSE DO:
               ASSIGN reservas.cod-depos:screen-value  in frame {&frame-name}  = reservas.cod-depos:screen-value  in frame {&frame-name}.
           END.


           assign de-saldo-incrementa               = reservas.quant-orig when avail reservas.

           if item.loc-unica = yes then
              disable reservas.cod-localiz with frame {&frame-name}.
           else
              enable reservas.cod-localiz with frame {&frame-name}. 
/*                                                                        */
/*               if item.tipo-con-est > 1 then                            */
/*                  enable reservas.lote-serie with frame {&frame-name}.  */
/*               else                                                     */
/*                  disable reservas.lote-serie with frame {&frame-name}. */

           run notify ('pi-inicializa-unidade,group-assign-target').    

              if param-global.modulo-per-ppm then do:

                  run notify ('pi-valida-tipo-formula,group-assign-target').
                  find ord-prod where rowid(ord-prod) = v-row-parent no-lock no-error.

                  assign tg-veiculo:visible        in frame {&frame-name} = FALSE.
                  case item.tipo-formula:
                      when 2 then
                          run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                      when 3 then
                          run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                      WHEN 4 THEN DO: /*Ve°culo*/
                          run pi-formata-campo (fi-per-ppm:handle, true, TRUE, 100, "%":U, ">>9.9999":U).

                          assign tg-veiculo:visible        in frame {&frame-name} = true
                                 tg-veiculo:sensitive      in frame {&frame-name} = if ord-prod.estado = 1 then TRUE else FALSE 
                                 tg-veiculo:checked        in frame {&frame-name} = IF  (ord-prod.estado = 1 AND reservas.per-ppm > 0) THEN TRUE ELSE FALSE. 

                          APPLY "value-changed":U TO tg-veiculo IN FRAME f-main.
                      END.
                      otherwise
                          run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
                  end case.
              end.
           
            if item.tipo-con-est = 4 then do:
              enable reservas.cod-refer with frame {&frame-name}.
              IF reservas.cod-refer:SCREEN-VALUE in frame {&frame-name} = "" THEN DO:
                  apply "entry" to reservas.cod-refer in frame {&frame-name}.
                  return no-apply.
              END.
           end.
           else do:
              disable reservas.cod-refer with frame {&frame-name}.
              assign reservas.cod-refer:screen-value in frame {&frame-name} = ""
                     fi-referencia-descricao:screen-value in frame {&frame-name} = "".
           end. 

        end.
        else
            assign fi-item-descricao = "".

        display fi-item-descricao 
                fi-referencia-descricao with frame {&frame-name}.

        if c-nom-prog-upc-mg97 <> "":U then do:
            run value(c-nom-prog-upc-mg97) (input "leave-it-codigo":U,
                                            input "viewer",
                                            input this-procedure:handle,
                                            input frame {&frame-name}:handle,
                                            input "ord-prod":U,
                                            input rowid(ord-prod)).      
        end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.it-codigo IN FRAME f-main /* Item Reserva */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.item-pai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.item-pai V-table-Win
ON F5 OF reservas.item-pai IN FRAME f-main /* Item Pai */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=reservas.item-pai
                     &campozoom=it-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.item-pai V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.item-pai IN FRAME f-main /* Item Pai */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.lote-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.lote-serie V-table-Win
ON F5 OF reservas.lote-serie IN FRAME f-main /* Lote/SÇrie */
DO:
  ASSIGN c-it-codigo = reservas.it-codigo:SCREEN-VALUE IN FRAME {&frame-name}
         c-estab     = "".

  {include/zoomvar.i
    &prog-zoom  = "inzoom/z02in403.w"
    &campo      = reservas.lote-serie
    &campozoom  = lote}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.lote-serie V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.lote-serie IN FRAME f-main /* Lote/SÇrie */
DO:
   APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.op-codigo V-table-Win
ON F5 OF reservas.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
    find ord-prod where rowid(ord-prod) = v-row-parent no-lock no-error.
    assign i-ordem = ord-prod.nr-ord-prod.

    {include/zoomvar.i &prog-zoom="inzoom/z02in260.w"
                       &campo=reservas.item-pai
                       &campozoom=it-codigo
                       &campo2=reservas.cod-roteiro
                       &campozoom2=cod-roteiro
                       &campo3=reservas.op-codigo
                       &campozoom3=op-codigo}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-veiculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-veiculo V-table-Win
ON VALUE-CHANGED OF tg-veiculo IN FRAME f-main /* Ve°culo / Excipiente */
DO:
        IF tg-veiculo:CHECKED IN FRAME f-main THEN DO:
            ASSIGN fi-per-ppm:SENSITIVE    IN FRAME f-main = tg-veiculo:SENSITIVE in frame {&frame-name}
                   fi-per-ppm:SCREEN-VALUE IN FRAME f-main = IF tg-veiculo:SENSITIVE in frame {&frame-name}
                                                             AND (NOT AVAIL reservas OR reservas.per-ppm = 0)
                                                             THEN "100":U
                                                             ELSE string(reservas.per-ppm).
        END.
        ELSE
            ASSIGN fi-per-ppm:SENSITIVE    IN FRAME f-main = NO
                   fi-per-ppm:SCREEN-VALUE IN FRAME f-main = "0":U.
      
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

  if reservas.it-codigo:load-mouse-pointer ("image/lupa.cur")   in frame {&frame-name} then.
  if reservas.item-pai:load-mouse-pointer ("image/lupa.cur")    in frame {&frame-name} then.
  if reservas.cod-depos:load-mouse-pointer ("image/lupa.cur")   in frame {&frame-name} then.
  if reservas.op-codigo:load-mouse-pointer ("image/lupa.cur")   in frame {&frame-name} then.
  if reservas.cod-refer:load-mouse-pointer ("image/lupa.cur")   in frame {&frame-name} then.
  if reservas.cod-localiz:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if reservas.cod-roteiro:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if reservas.lote-serie:load-mouse-pointer ("image/lupa.cur")   in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "reservas"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "reservas"}

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
  find ord-prod where rowid(ord-prod) = v-row-parent no-lock no-error.
  find first reservas 
       where reservas.nr-ord-produ = ord-prod.nr-ord-produ 
       and   reservas.item-pai     = ord-prod.it-codigo
       no-lock no-error.

  if avail reservas then do:
     assign reservas.cod-roteiro:screen-value in frame {&frame-name} = reservas.cod-roteiro
            reservas.op-codigo:screen-value   in frame {&frame-name} = string (reservas.op-codigo).
  end.

  assign reservas.item-pai:screen-value    in frame {&frame-name} = ord-prod.it-codigo.

    if param-global.modulo-per-ppm then do:
        assign tg-veiculo:checked in frame {&frame-name} = false
               tg-veiculo:visible in frame {&frame-name} = false.
        run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
    end.

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

DEF BUFFER bf-item FOR ITEM.

DEF VAR op-codigo-old LIKE reservas.op-codigo NO-UNDO.
DEF VAR cod-roteiro-old LIKE reservas.cod-roteiro NO-UNDO.

DO TRANSACTION:
  find first param-global no-lock no-error.
  find ord-prod where rowid(ord-prod) = v-row-parent no-lock no-error.
  find item where item.it-codigo = input frame {&frame-name} reservas.it-codigo no-lock no-error.

  FOR FIRST item-uni-estab FIELDS (tipo-requis cod-obsoleto)
      WHERE item-uni-estab.it-codigo = input frame {&frame-name} reservas.it-codigo
        AND item-uni-estab.cod-estabel = ord-prod.cod-estabel NO-LOCK:
  END.
  
  if reservas.it-codigo:sensitive in frame {&frame-name} then do: 
     find reservas where reservas.nr-ord-produ = ord-prod.nr-ord-produ
                     and reservas.it-codigo    = input reservas.it-codigo
                     and reservas.item-pai     = input reservas.item-pai
                     and reservas.cod-roteiro  = input reservas.cod-roteiro
                     and reservas.op-codigo    = input reservas.op-codigo
                     and reservas.cod-refer    = input reservas.cod-refer
                     no-lock no-error.
     if avail reservas then do:
        run utp/ut-msgs.p (input "show",
                           input 1680,
                           input "").                                            
        apply 'entry' to reservas.cod-refer.
        return 'ADM-ERROR':U.
     end.
  end. 
  else do:
     if input frame {&frame-name} reservas.cod-refer <> reservas.cod-refer then do:

        if not item.alt-refer then do:
           run utp/ut-msgs.p (input "show",
                              input 1232,
                              input "").
           apply 'entry' to reservas.cod-refer.
           return 'ADM-ERROR':U.
        end.

        find b-reservas where b-reservas.nr-ord-produ = ord-prod.nr-ord-produ
                          and b-reservas.it-codigo    = input reservas.it-codigo
                          and b-reservas.item-pai     = input reservas.item-pai
                          and b-reservas.cod-roteiro  = input reservas.cod-roteiro
                          and b-reservas.op-codigo    = input reservas.op-codigo
                          and b-reservas.cod-refer    = input reservas.cod-refer
                       no-lock no-error.
        if avail b-reservas then do:
           run utp/ut-msgs.p (input "show",
                              input 1680,
                              input "").                                            
           apply 'entry' to reservas.cod-refer.
           return 'ADM-ERROR':U.
        end.
     end.
  end.
  if input reservas.it-codigo = ? or input reservas.it-codigo = "" then do: 
     run utp/ut-msgs.p (input "show",
                        input 1673,
                        input "").
     apply 'entry' to reservas.it-codigo.
     return 'ADM-ERROR':U.
  end.
  
  IF AVAIL item-uni-estab THEN DO:
     IF item-uni-estab.cod-obsoleto >= 3 then do:

        run utp/ut-msgs.p (input "show",
                           input 563,
                           input "").
        apply 'entry' to reservas.it-codigo.
        return 'ADM-ERROR':U.
     END.

     IF item-uni-estab.tipo-requis = 3 then do: 
        run utp/ut-msgs.p (input "show",
                           input 1675,
                           input "").
        apply 'entry' to reservas.it-codigo.
        return 'ADM-ERROR':U.
     END.
  END.
  ELSE DO: 
      
     IF item.cod-obsoleto >= 3 then do: 
  
         RUN utp/ut-msgs.p (input "show",
                            input 563,
                            input "").
         APPLY 'entry' to reservas.it-codigo.
         RETURN 'ADM-ERROR':U.
     END.
     IF item.tipo-requis >= 3 then do: 
         run utp/ut-msgs.p (input "show",
                            input 563,
                            input "").
         apply 'entry' to reservas.it-codigo.
         return 'ADM-ERROR':U.
     END.
  END.

  if item.tipo-contr = 4 then do: 
     run utp/ut-msgs.p (input "show",
                        input 1673,
                        input "").
     apply 'entry' to reservas.it-codigo.
     return 'ADM-ERROR':U. 
  end.
  if item.it-codigo = ord-prod.it-codigo and
         (ord-prod.tipo <> 5 and ord-prod.tipo <> 9) then do:
     run utp/ut-msgs.p (input "show",
                        input 1677,
                        input "").
     apply 'entry' to reservas.it-codigo.
     return 'ADM-ERROR':U.
  end.
  if item.tipo-con-est = 4 then do:
     find ref-item use-index item
          where ref-item.it-codigo = input reservas.it-codigo
          and ref-item.cod-refer   = input reservas.cod-refer no-lock no-error.

     if not avail ref-item then do: 
        run utp/ut-msgs.p (input "show",
                           input 529,
                           input "").
        apply 'entry' to reservas.cod-refer.
        return 'ADM-ERROR':U.                                    
     end.
  end.


  /*** Validaá‰es para o Item-Pai da Reserva***/

  FIND FIRST bf-item WHERE bf-item.it-codigo = input frame {&frame-name} reservas.item-pai no-lock no-error.
  IF NOT AVAIL bf-item THEN DO:
     {utp/ut-liter.i ITEM *}
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input RETURN-VALUE).
     apply 'entry' to reservas.item-pai.
     return 'ADM-ERROR':U.
  END.


  if not(input reservas.cod-roteiro = "") or 
     not(input reservas.op-codigo = 0) then do:
     find oper-ord where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                   and oper-ord.it-codigo    = input reservas.item-pai
                   and oper-ord.cod-roteiro  = input reservas.cod-roteiro
                   and oper-ord.op-codigo    = input reservas.op-codigo
                   no-lock no-error.
     if not avail oper-ord then do: 
        run utp/ut-msgs.p (input "show",
                           input 1685,
                           input "").
        apply 'entry' to reservas.op-codigo.
        return 'ADM-ERROR':U.                   
     end.
  end.
  FIND FIRST deposito WHERE deposito.cod-depos = 
          input frame {&frame-name} reservas.cod-depos NO-LOCK NO-ERROR.
        IF NOT AVAIL deposito THEN DO:
          {utp~/ut-liter.i "Dep¢sito Inexistente!"}
           run utp/ut-msgs.p (input "show",
                              input 17567,
                              input RETURN-VALUE).
              apply 'entry' TO reservas.cod-depos in frame {&frame-name}.
              return 'ADM-ERROR':U.                         
         END.


  if  reservas.cod-localiz:sensitive in frame {&frame-name} = yes
      and avail ord-prod then do:
      find mgind.localizacao where 
           localizacao.cod-localiz = input frame {&frame-name} reservas.cod-localiz
           and   localizacao.cod-depos   = input frame {&frame-name} reservas.cod-depos
           and   localizacao.cod-estabel = ord-prod.cod-estabel
           no-lock no-error.
      if  not avail localizacao then do:
          run utp/ut-msgs.p (input "show",
                             input 6662,
                             input "").
          apply 'entry' TO reservas.cod-localiz in frame {&frame-name}.
          return "adm-error".                           
      end.      
  end.
  find item where item.it-codigo = input reservas.it-codigo no-lock no-error.
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                INPUT "quant-orig").
  if decimal (return-value) = 0 then do:
     run utp/ut-msgs.p (input "show",
                        input 1368,
                        input "").
    return 'ADM-ERROR':U.
  end.
 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                               INPUT "quant-atend").
 assign de-quant-atend = decimal (return-value).
 if not reservas.it-codigo:sensitive in frame {&frame-name} then do:
    RUN get-attribute IN adm-broker-hdl (INPUT "l-digitacao").
    if (return-value = 'yes' or return-value = ?) 
        and de-quant-atend <> reservas.quant-atend then do:
        run utp/ut-msgs.p (input "show",
                           input 1724,
                           input "").
        if return-value = "no" then do:
          /* assign reservas.quant-atend:screen-value = string (reservas.quant-atend). */
           return 'ADM-ERROR':U.
        end.
    end.
    assign de-aux = reservas.quant-orig.
 end.
 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                               INPUT "un").
 if return-value <> item.un then do:
    run utp/ut-msgs.p (input "show",
                       input 848,
                       input "").                                     
    return 'ADM-ERROR':U.
 end.
 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                               INPUT "quant-orig").                                  
 if not (item.fraciona) and
    decimal (return-value) <> integer (return-value) then do:
    run utp/ut-msgs.p (input "show",
                       input 847,
                       input "").
    return 'ADM-ERROR':U.
 end. 

 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                               INPUT "dt-reserva").
 if return-value = "" or  return-value = ? or
     date (return-value) < ord-prod.dt-inicio or
     date (return-value) > ord-prod.dt-termino then do:
     run utp/ut-msgs.p (input "show",
                        input 1692,
                        input string (ord-prod.dt-inicio) + "~~" +
                              string (ord-prod.dt-termino)).
     return 'ADM-ERROR':U.            
 end.

    /*Projeto Controle de Potància - 346 - Dever† permitir a inclus∆o de mais de um ve°culo na reserva da ordem*/

    assign tg-veiculo = tg-veiculo:checked in frame {&frame-name}
           fi-per-ppm = INPUT FRAME f-main fi-per-ppm.

    IF ITEM.tipo-formula = 4 THEN DO:
        /*Percentual deve ser diferente de zero.*/
        if tg-veiculo:CHECKED IN FRAME f-main AND
           (INPUT FRAME f-main fi-per-ppm <= 0 OR INPUT FRAME f-main fi-per-ppm = ?) then do:
            {utp/ut-liter.i %_Distrib._Ve°culo *}
            run utp/ut-msgs.p (input "show",
                               input 2333,
                               input RETURN-VALUE). 
            apply "entry" to fi-per-ppm in frame {&frame-name}.
            return "adm-error":U.
        end.
    END.

 IF AVAIL reservas THEN DO:
     ASSIGN op-codigo-old   = reservas.op-codigo
            cod-roteiro-old = reservas.cod-roteiro.
    
    IF  reservas.nr-req-sum <> 0
    AND reservas.cod-refer  <> INPUT reservas.cod-refer
    THEN DO:
        {utp/ut-liter.i "OP Sumarizada. Para alterar ser† necess†rio exclus∆o a sumarizaá∆o." *}
        run utp/ut-msgs.p (input "show",
                           input 17567,
                           input RETURN-VALUE). 
        apply "entry" to reservas.cod-refer in frame {&frame-name}.
        return "adm-error":U.

    END.
 END.

 /* Dispatch standard ADM method.                             */
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
 if RETURN-VALUE = 'ADM-ERROR':U then 
    RETURN 'ADM-ERROR':U.

 IF AVAIL reservas and
     (reservas.op-codigo   <> op-codigo-old or
      reservas.cod-roteiro <> cod-roteiro-old) THEN DO:

     FOR EACH aloca-reserva
         FIELDS(nr-ord-prod item-pai it-codigo op-codigo cod-roteiro) WHERE
         aloca-reserva.nr-ord-prod = reservas.nr-ord-prod AND
         aloca-reserva.item-pai    = reservas.item-pai    AND
         aloca-reserva.it-codigo   = reservas.it-codigo   AND
         aloca-reserva.op-codigo   = op-codigo-old        AND
         aloca-reserva.cod-roteiro = cod-roteiro-old EXCLUSIVE-LOCK:

         ASSIGN aloca-reserva.op-codigo   = reservas.op-codigo
                aloca-reserva.cod-roteiro = reservas.cod-roteiro.
     END.
 END.

  assign c-reservas-aux        = reservas.tp-atualiza
         reservas.nr-ord-produ = ord-prod.nr-ord-produ
         reservas.tp-atualiza = IF c-reservas-aux <> 9 
                                   THEN 0
                                ELSE 9.                

     if param-global.modulo-per-ppm THEN DO:
        assign reservas.tipo-formula = item.tipo-formula
               reservas.per-ppm      = item.per-ppm
               reservas.veiculo      = tg-veiculo:checked in frame {&frame-name}.

        IF reservas.veiculo THEN
            ASSIGN reservas.per-ppm = fi-per-ppm.
     END.
     else
        assign reservas.tipo-formula = 1
               reservas.per-ppm      = 0
               reservas.veiculo      = false.

  if not reserva.it-codigo:sensitive in frame {&frame-name} then do:
     RUN get-attribute IN adm-broker-hdl
         (INPUT "l-digitacao").
     if return-value = "no" then do:
        run get-field-screen-value in adm-broker-hdl
           (INPUT this-procedure,
            INPUT "fi-ajuste").
        assign reservas.quant-orig = reservas.quant-orig + decimal (return-value).
     end.
  end.

  /*** Faz o acerto das alocaá‰es ***/
  if not reserva.it-codigo:sensitive in frame {&frame-name} and
     reservas.quant-aloc > reservas.quant-orig - reservas.quant-atend then do:
      if not valid-handle(h-cpapi013) then
          run cpp/cpapi013.p persistent set h-cpapi013 (input        table tt-alocacao,
                                                        input        table tt-deposito,
                                                        input-output table tt-erro,
                                                        input        yes).

      run pi-recalcula-aloc in h-cpapi013 (input rowid(reservas)).

  end.


  if not(ord-prod.nr-req-sum = 0) and
     item.tipo-requis = 1 AND
      reservas.quant-orig > 0 then do:

      assign reserva.nr-req-sum = ord-prod.nr-req-sum.

      if not valid-handle (h-cpapi018) then
          run cpp/cpapi018.p persistent set h-cpapi018 (input        table tt-dados,
                                                        input        table tt-ord-prod-2,
                                                        input-output table tt-req-sum,
                                                        input-output table tt-erro,
                                                        input        yes).

      if reservas.it-codigo:sensitive then
          run pi-atualiza-quantidade in h-cpapi018 (input rowid(reservas),
                                                    input 0).

      else 
          if de-aux <> reservas.quant-orig then
              run pi-atualiza-quantidade in h-cpapi018 (input rowid(reservas),
                                                        input de-aux).

      if return-value = 'nok':u then do:       
          run pi-retorna-tt-erro in h-cpapi018 (output table tt-erro).
          if can-find (first tt-erro) then do:

              run cdp/cd0666.w (input table tt-erro).

              empty temp-table tt-erro.

              run pi-recebe-tt-erro in h-cpapi018 (input table tt-erro).

           end.
           /*return 'ADM-ERROR':U.*/
      end.

  end.

  /* o programa abaixo ir† setar o campo replaneja do pl-it-calc 
      para que antes da confirmaá∆o do calculo o planejamento seja 
      calculado novamente por que o item foi alterado.*/

  if param-global.modulo-pl or param-global.modulo-pi  then 
     run cdp/cd7000.p(input 0,
                      reservas.it-codigo,
                      ord-prod.cod-estabel).

  /* Chamada do adapter sender de Ordem de Produá∆o EAI */
  /* Execucao caso usuario possua integracao EAI */
  IF v_log_eai_habilit and
     return-value <> "ADM-ERROR":U  THEN DO:

   /*  IF AVAIL ord-prod THEN DO:
        CREATE tt-ord-prod.
        BUFFER-COPY ord-prod TO tt-ord-prod.
        RUN adapters~/xml~/ma2~/axsma007.p (INPUT "upd",
                                         INPUT "v05in390.w",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT TABLE tt-ord-prod,
                                         OUTPUT TABLE RowErrors).  
         DELETE tt-ord-prod.
         FIND FIRST RowErrors WHERE 
                    RowErrors.ErrorSubType = "ERROR":U NO-LOCK NO-ERROR.
         IF AVAIL RowErrors THEN DO:
             run utp/ut-msgs.p (input "show",
                                input RowErrors.ErrorNumber,
                                input RowErrors.ErrorDescription).
             UNDO, return 'ADM-ERROR':U.
             /*return 'ADM-ERROR':U.*/


         END.
     END.*/
  END.


END. /* Transaction */


RUN warningVeiculo.
  


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

  if valid-handle (h-cpapi013) then 
    run pi-finalizar in h-cpapi013.

  if valid-handle (h-cpapi018) then
    run pi-finalizar in h-cpapi018.

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
  if avail reservas then do:
     find item where
          item.it-codigo = reservas.it-codigo no-lock no-error.
     if avail item then 
        assign fi-item-descricao = item.desc-item.
     else
         assign fi-item-descricao = "".

     IF ITEM.politica = 5 THEN DO:

         FIND cot-est-mast no-lock
             WHERE cot-est-mast.item-cotacao = reservas.it-codigo
               AND cot-est-mast.nr-estrut    = INT(reservas.cod-refer)
             NO-ERROR.

         IF AVAIL cot-est-mast THEN 
             assign fi-referencia-descricao = cot-est-mast.descricao.
     END.
     ELSE DO:
         find ref-item use-index item
            where ref-item.it-codigo = reservas.it-codigo
              and ref-item.cod-refer = reservas.cod-refer
            no-lock no-error.
         if avail ref-item then do:
            find referencia of ref-item no-lock no-error.
            if avail referencia then
             assign fi-referencia-descricao = referencia.descricao.
         end.    
     END.
  end.

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


  def buffer b-reservas for reservas.

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if avail reservas then do:
     find item where item.it-codigo = reservas.it-codigo
       no-lock no-error.
     if avail item then do:
        if item.tipo-con-est = 4 then
           enable reservas.cod-refer with frame {&frame-name}.
        else
           disable reservas.cod-refer with frame {&frame-name}.

        if item.loc-unica = yes then
           disable reservas.cod-localiz with frame {&frame-name}.
        else
           enable reservas.cod-localiz with frame {&frame-name}. 

        if item.tipo-con-est > 1 then
           enable reservas.lote-serie with frame {&frame-name}.
        else     
           disable reservas.lote-serie with frame {&frame-name}.

          FIND FIRST ord-prod WHERE ord-prod.it-codigo = reservas.it-codigo AND ord-prod.nr-ord-produ = reservas.nr-ord-produ AND ord-prod.estado = 1 NO-LOCK NO-ERROR.
               IF quant-atend = 0 THEN
                   ENABLE reservas.op-codigo WITH FRAME {&FRAME-NAME}.
           if param-global.modulo-per-ppm then do:
               run notify ('pi-valida-tipo-formula,group-assign-target').
               find ord-prod where rowid(ord-prod) = v-row-parent no-lock no-error.
               case item.tipo-formula:
                   when 2 then
                       run pi-formata-campo (fi-per-ppm:handle, true, false, reservas.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                   when 3 then
                       run pi-formata-campo (fi-per-ppm:handle, true, false, reservas.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                   WHEN 4 THEN DO: /*Ve°culo*/
                       run pi-formata-campo (fi-per-ppm:handle, true, TRUE, reservas.per-ppm, "%":U, ">>9.9999":U).

                       assign tg-veiculo:visible        in frame {&frame-name} = TRUE
                              tg-veiculo:sensitive      in frame {&frame-name} = if ord-prod.estado = 1 then TRUE ELSE FALSE
                              tg-veiculo:checked        in frame {&frame-name} = IF (reservas.veiculo AND reservas.per-ppm > 0) THEN TRUE ELSE FALSE. 

                       APPLY "value-changed":U TO tg-veiculo IN FRAME f-main.
                   END.
                   OTHERWISE DO:
                       run pi-formata-campo (tg-veiculo:handle, false, false, 0, "", "").
                       run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
                   END.
               end case.

           end.
     end.
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
    def var h-handle as handle no-undo.

    find first param-global no-lock no-error.

    if NOT param-global.modulo-per-ppm then
        assign tg-veiculo:visible in frame {&frame-name} = false
               fi-per-ppm:visible in frame {&frame-name} = false.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campo V-table-Win 
PROCEDURE pi-formata-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle      as handle no-undo.
def input param pVisible     as log    no-undo.
def input param pSensitive   as log    no-undo.
def input param pScreenValue as dec    no-undo.
def input param pLabel       as char   no-undo.
def input param pFormat      as char   no-undo.

    if pVisible then
        assign pHandle:visible      = pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = string(pScreenValue)
               pHandle:label        = pLabel no-error.
    else
        assign pHandle:visible = pVisible no-error.

return 'ok':u.

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
  {src/adm/template/snd-list.i "reservas"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE warningVeiculo V-table-Win 
PROCEDURE warningVeiculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE de-soma-perc  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-componentes AS CHARACTER   NO-UNDO.

      if param-global.modulo-per-ppm THEN DO:

          IF reservas.veiculo AND reservas.estado = 1 /*Ativo*/ THEN DO:
              /*Tratamento de Gravaá∆o do Percentual de Distribuiá∆o do Ve°culo*/
                     
              IF can-find (first b-reservas NO-LOCK use-index veiculo 
                           WHERE b-reservas.nr-ord-produ = reservas.nr-ord-produ
                             and b-reservas.veiculo      =  true                
                             AND b-reservas.estado       = 1 /*Ativo*/
                             and rowid(b-reservas)       <> rowid(reservas)) then DO:
                  /*caso exista mais de um componente na estrutura usando este ve°culo,
                    emite warning avisando que o usu†rio dever† ajustar os percentuais em quest∆o.*/

                  FOR EACH b-reservas NO-LOCK use-index veiculo 
                     WHERE b-reservas.nr-ord-produ = reservas.nr-ord-produ
                       and b-reservas.veiculo      = true                
                       AND b-reservas.estado       = 1: /*Ativo*/

                      ASSIGN de-soma-perc = de-soma-perc + b-reservas.per-ppm
                             c-componentes = c-componentes +     
                             STRING(b-reservas.cod-roteiro) + " / ":U + STRING(b-reservas.op-codigo) + " / ":U + 
                             STRING(b-reservas.it-codigo) + " / ":U + STRING(b-reservas.cod-refer) + ": ":U + 
                             STRING(b-reservas.per-ppm) + "%":U + CHR(13).
                  END.

                  IF de-soma-perc <> 100 AND c-componentes <> "":U THEN 
                      run utp/ut-msgs.p (input "show":U, input 33958, input c-componentes).

              END. /*IF can-find (first b-reservas*/
          END.
      END.
  
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


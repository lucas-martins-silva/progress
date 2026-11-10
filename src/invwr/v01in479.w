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
{include/i-prgvrs.i V01IN479 2.00.00.028 } /*** "010028" 22/07/2026 15:00:13 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in479 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgman.i}

/* global variable definitions */
def new global shared var gr-lista          as rowid no-undo.                                
def new global shared var v-row-parent      as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-lista-compon      for lista-compon.
def buffer b-item-lista-compon for item-lista-compon.
DEF BUFFER b-item              FOR ITEM.

def var rw-lista       as rowid no-undo.
def var rw-lista-ant   as rowid no-undo.
def var c-texto        as char format "x(12)".
def var h-boin479      as handle no-undo.

def var h-campo    as handle no-undo.

DEF TEMP-TABLE tt-datas NO-UNDO
    FIELD dt-trans     AS DATE
    FIELD de-soma-perc AS DEC DECIMALS 4
    INDEX id-trans dt-trans
    INDEX id-soma  de-soma-perc.

DEF TEMP-TABLE tt-estruts NO-UNDO
    FIELD sequencia AS INT
    FIELD es-codigo AS CHAR
    FIELD dt-trans  AS DATE
    FIELD perc       AS DEC DECIMALS 4
    INDEX id-a  sequencia es-codigo dt-trans
    INDEX id-dt dt-trans.

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
&Scoped-define EXTERNAL-TABLES item-lista-compon
&Scoped-define FIRST-EXTERNAL-TABLE item-lista-compon


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-lista-compon.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-lista-compon.fantasma ~
item-lista-compon.qtd-lista item-lista-compon.fator-perda ~
item-lista-compon.proporcao item-lista-compon.qtd-compon ~
item-lista-compon.log-quant-fix item-lista-compon.tempo-reserv ~
item-lista-compon.data-inicio item-lista-compon.data-termino ~
item-lista-compon.log-compon-altern 
&Scoped-define ENABLED-TABLES item-lista-compon
&Scoped-define FIRST-ENABLED-TABLE item-lista-compon
&Scoped-Define ENABLED-OBJECTS fi-per-ppm rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS ~
item-lista-compon.cod-lista-compon item-lista-compon.sequencia ~
item-lista-compon.es-codigo item-lista-compon.cod-ref-es item-lista-compon.log-quant-fix ~
item-lista-compon.qtd-lista item-lista-compon.fator-perda ~
item-lista-compon.proporcao item-lista-compon.qtd-compon ~
item-lista-compon.tempo-reserv ~
item-lista-compon.data-inicio item-lista-compon.data-termino ~
item-lista-compon.fantasma item-lista-compon.log-compon-altern 
&Scoped-define DISPLAYED-TABLES item-lista-compon
&Scoped-define FIRST-DISPLAYED-TABLE item-lista-compon
&Scoped-Define DISPLAYED-OBJECTS c-desc-lista c-desc1 qt-liquida tg-veiculo ~
fi-per-ppm c-un-lista c-un c-desc-ref 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item-lista-compon.sequencia ~
item-lista-compon.es-codigo 
&Scoped-define ADM-ASSIGN-FIELDS item-lista-compon.cod-ref-es tg-veiculo 
&Scoped-define ADM-MODIFY-FIELDS qt-liquida 

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
DEFINE VARIABLE c-desc-lista AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc1 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-lista AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE qt-liquida AS DECIMAL FORMAT "->>>,>>9.9999999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 6.38.

DEFINE VARIABLE tg-veiculo AS LOGICAL INITIAL no 
     LABEL "Ve¡culo / Excipiente" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-lista-compon.cod-lista-compon AT ROW 1.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-lista AT ROW 1.17 COL 39.29 COLON-ALIGNED NO-LABEL
     item-lista-compon.sequencia AT ROW 2.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     item-lista-compon.es-codigo AT ROW 3.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc1 AT ROW 3.17 COL 39.29 COLON-ALIGNED NO-LABEL
     item-lista-compon.cod-ref-es AT ROW 4.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     item-lista-compon.log-quant-fix AT ROW 5.54 COL 24
          LABEL "Quantidade Fixa"
          VIEW-AS TOGGLE-BOX
          SIZE 17.72 BY .88
     item-lista-compon.qtd-lista AT ROW 6.54 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     item-lista-compon.fator-perda AT ROW 7.54 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     item-lista-compon.proporcao AT ROW 8.54 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-lista-compon.qtd-compon AT ROW 9.54 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     qt-liquida AT ROW 10.54 COL 22 COLON-ALIGNED
     tg-veiculo AT ROW 5.54 COL 49
     fi-per-ppm AT ROW 5.54 COL 66 COLON-ALIGNED
     item-lista-compon.tempo-reserv AT ROW 6.54 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     item-lista-compon.data-inicio AT ROW 7.54 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     item-lista-compon.data-termino AT ROW 8.54 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-un-lista AT ROW 6.54 COL 37 COLON-ALIGNED NO-LABEL
     c-un AT ROW 9.54 COL 39.43 COLON-ALIGNED NO-LABEL
     c-desc-ref AT ROW 4.17 COL 34.57 COLON-ALIGNED NO-LABEL
     item-lista-compon.fantasma AT ROW 9.5 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 12.72 BY .83
     item-lista-compon.log-compon-altern AT ROW 9.5 COL 68
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .83
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-lista-compon
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
         HEIGHT             = 10.88
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-lista IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-lista IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-lista-compon.cod-lista-compon IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-lista-compon.cod-ref-es IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-lista-compon.es-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX item-lista-compon.log-quant-fix IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN qt-liquida IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN item-lista-compon.sequencia IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME item-lista-compon.cod-ref-es
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.cod-ref-es V-table-Win
ON F5 OF item-lista-compon.cod-ref-es IN FRAME f-main /* Ref Componente */
DO:
  assign l-implanta = yes. 
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=item-lista-compon.cod-ref-es
                     &campozoom=cod-refer
                     &campo2=c-desc-ref
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa (input item-lista-compon.es-codigo:screen-value in frame {&frame-name})."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.cod-ref-es V-table-Win
ON LEAVE OF item-lista-compon.cod-ref-es IN FRAME f-main /* Ref Componente */
DO:

    /* se encontrar referˆncia para o item, busca descri‡Æo */
     if CAN-FIND (FIRST ref-item WHERE
                    ref-item.cod-refer = input frame {&frame-name} item-lista-compon.cod-ref-es and
                    ref-item.it-cod = input frame {&frame-name} item-lista-compon.es-codigo) then do: 
                
            {include/leave.i &tabela=referencia
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-ref
                     &where="referencia.cod-refer = input frame {&frame-name} item-lista-compon.cod-ref-es"}    
     end.
     else
         c-desc-ref:screen-value in frame {&frame-name} = " ".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.cod-ref-es V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-lista-compon.cod-ref-es IN FRAME f-main /* Ref Componente */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-lista-compon.es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.es-codigo V-table-Win
ON F5 OF item-lista-compon.es-codigo IN FRAME f-main /* Componente */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                       &campo=item-lista-compon.es-codigo
                       &campozoom=it-codigo
                       &campo2=c-desc1
                       &campozoom2=desc-item}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.es-codigo V-table-Win
ON LEAVE OF item-lista-compon.es-codigo IN FRAME f-main /* Componente */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc1
                   &atributo-ref2=un
                   &variavel-ref2=c-un
                   &where="item.it-codigo = input frame {&frame-name} item-lista-compon.es-codigo"}
  if avail item then do:
     if item.tipo-con-est = 4 then do:
        assign item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes.
        apply "entry" to item-lista-compon.cod-ref-es in frame {&frame-name}.
        return no-apply.
     end.
     else
        assign item-lista-compon.cod-ref-es:screen-value in frame {&frame-name} = " "
               c-desc-ref:screen-value in frame {&frame-name} = " "
               item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = no.

     &IF DEFINED (bf_man_per_ppm) &THEN
        if param-global.modulo-per-ppm then do:
            /*Permite que seja incluido mais de um componente ve¡culo para o mesmo item.*/
/*             if item.tipo-formula = 4 then do:                                                                                                            */
/*                 if not can-find (first b-item-lista-compon where                                                                                         */
/*                                        b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} and */
/*                                        b-item-lista-compon.veiculo) then                                                                                 */
/*                     assign tg-veiculo:visible   in frame {&frame-name} = true                                                                            */
/*                            tg-veiculo:sensitive in frame {&frame-name} = true                                                                            */
/*                            tg-veiculo:checked   in frame {&frame-name} = true.                                                                           */
/*                 else                                                                                                                                     */
/*                     assign tg-veiculo:visible   in frame {&frame-name} = true                                                                            */
/*                            tg-veiculo:sensitive in frame {&frame-name} = false                                                                           */
/*                            tg-veiculo:checked   in frame {&frame-name} = false.                                                                          */
/*             end.                                                                                                                                         */
/*             else                                                                                                                                         */
/*                 assign tg-veiculo:checked in frame {&frame-name} = false                                                                                 */
/*                        tg-veiculo:visible in frame {&frame-name} = false.                                                                                */
            
            case item.tipo-formula:
                when 2 then
                    run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                when 3 then                
                    run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                WHEN 4 THEN DO:

                    run pi-formata-campo (fi-per-ppm:handle, true, TRUE, 100, "%":U, ">>9.9999":U).
                                          
                    assign tg-veiculo:visible   in frame {&frame-name} = true 
                           tg-veiculo:SENSITIVE in frame {&frame-name} = true
                           tg-veiculo:checked   in frame {&frame-name} = TRUE. 
                                          
                    APPLY "value-changed":U TO tg-veiculo IN FRAME f-main.
                END.
                otherwise
                    run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
            end case.
        
        end.
     &ENDIF
     
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.es-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-lista-compon.es-codigo IN FRAME f-main /* Componente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-lista-compon.fator-perda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.fator-perda V-table-Win
ON LEAVE OF item-lista-compon.fator-perda IN FRAME f-main /* Fator Perda */
DO:
  ASSIGN qt-liquida:SCREEN-VALUE = STRING((INPUT FRAME {&frame-name} item-lista-compon.qtd-compon) - 
                                         ((INPUT FRAME {&frame-name} item-lista-compon.qtd-compon) * 
                                         ((INPUT FRAME {&frame-name} item-lista-compon.fator-perda) / 100))).  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-lista-compon.log-quant-fix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.log-quant-fix V-table-Win
ON VALUE-CHANGED OF item-lista-compon.log-quant-fix IN FRAME f-main /* Quantidade Fixa */
DO:
    if  item-lista-compon.log-quant-fix:checked in frame {&frame-name} = YES THEN DO:
        assign  item-lista-compon.proporcao:SENSITIVE = FALSE
                item-lista-compon.proporcao:SCREEN-VALUE = "100"
                item-lista-compon.fator-perda:SENSITIVE = FALSE
                item-lista-compon.fator-perda:SCREEN-VALUE = "0"
                qt-liquida:SENSITIVE = FALSE
                qt-liquida:SCREEN-VALUE = INPUT FRAME {&frame-name} item-lista-compon.qtd-compon.
    END.
    ELSE DO:
        assign  item-lista-compon.proporcao:SENSITIVE = TRUE
                item-lista-compon.fator-perda:SENSITIVE = TRUE
                qt-liquida:SENSITIVE = TRUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qt-liquida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qt-liquida V-table-Win
ON LEAVE OF qt-liquida IN FRAME f-main
DO:
  ASSIGN item-lista-compon.qtd-compon:SCREEN-VALUE = STRING((INPUT FRAME {&frame-name} qt-liquida) / 
                                                     (1 - ((INPUT FRAME {&frame-name} item-lista-compon.fator-perda) / 100))).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-lista-compon.qtd-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.qtd-compon V-table-Win
ON LEAVE OF item-lista-compon.qtd-compon IN FRAME f-main /* Qtd Componente */
DO:
   ASSIGN qt-liquida:SCREEN-VALUE = STRING((INPUT FRAME {&frame-name} item-lista-compon.qtd-compon) - 
                                          ((INPUT FRAME {&frame-name} item-lista-compon.qtd-compon) * 
                                          ((INPUT FRAME {&frame-name} item-lista-compon.fator-perda) / 100))).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-veiculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-veiculo V-table-Win
ON VALUE-CHANGED OF tg-veiculo IN FRAME f-main /* Ve¡culo / Excipiente */
DO:
    &IF DEFINED(bf_man_205) &THEN
        IF tg-veiculo:CHECKED IN FRAME f-main THEN DO:
            ASSIGN fi-per-ppm:SENSITIVE    IN FRAME f-main = YES
                   fi-per-ppm:SCREEN-VALUE IN FRAME f-main = IF NOT AVAIL item-lista-compon OR
                                                                (
                                                                &IF DEFINED(bf_man_207A) &THEN                        
                                                                    item-lista-compon.val-perc-distrib-veic = 0 
                                                                &ELSE                                                 
                                                                    DEC(dec(SUBSTRING(item-lista-compon.char-1,6,7)) / 10000) = 0
                                                                &ENDIF 
                                                                )
                                                             THEN "100"
                                                             ELSE STRING(&IF DEFINED(bf_man_207A) &THEN                             
                                                                             item-lista-compon.val-perc-distrib-veic                    
                                                                         &ELSE                                                      
                                                                             DEC(dec(SUBSTRING(item-lista-compon.char-1,6,7)) / 10000) 
                                                                         &ENDIF).
        END.
        ELSE
            ASSIGN fi-per-ppm:SENSITIVE    IN FRAME f-main = NO
                   fi-per-ppm:SCREEN-VALUE IN FRAME f-main = "0":U.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

 {utp/ut-liter.i Sequˆncia *R}
 assign item-lista-compon.sequencia:label in frame {&frame-name} = trim(return-value).

 {utp/ut-liter.i In¡cio_Validade *R}
 assign item-lista-compon.data-inicio:label in frame {&frame-name} = trim(return-value).
 
 {utp/ut-field.i mgind estrutura quant-liquid 01}
 assign qt-liquida:label in frame {&frame-name} = return-value.
 
 if item-lista-compon.es-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if item-lista-compon.cod-ref-es:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 
 
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
  {src/adm/template/row-list.i "item-lista-compon"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-lista-compon"}

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
  display today @ item-lista-compon.data-inicio with frame {&frame-name}.
  /* Code placed here will execute AFTER standard behavior.    */
  
  if available lista-compon then
      disp lista-compon.cod-lista-compon @ item-lista-compon.cod-lista-compon 
           lista-compon.des-lista-compon @ c-desc-lista
           lista-compon.un               @ c-un-lista
           lista-compon.qtd-lista        @ item-lista-compon.qtd-lista  with frame {&frame-name}.
      
  find last param-en no-lock no-error.
  if not avail param-en then
     create param-en.
  find last b-item-lista-compon where 
       b-item-lista-compon.cod-lista-compon = lista-compon.cod-lista-compon no-lock no-error.
  if  avail b-item-lista-compon then 
     assign item-lista-compon.sequencia:screen-value in frame {&frame-name} = string(b-item-lista-compon.sequencia + param-en.num-var-estrutura).
  else
     assign item-lista-compon.sequencia:screen-value in frame {&frame-name} = string(param-en.num-var-estrutura).
      
  &IF DEFINED (bf_man_per_ppm) &THEN
    if param-global.modulo-per-ppm then
        assign item-lista-compon.fantasma:column in frame {&frame-name} = 51.00
               tg-veiculo:visible in frame {&frame-name} = false
               tg-veiculo:checked in frame {&frame-name} = false.
  &ENDIF 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    def var da-1 as date no-undo.
    def var da-2 as date no-undo.
    DEF BUFFER bf-tt-estruts FOR tt-estruts.
    DEFINE VARIABLE c-componentes AS CHARACTER   NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    /*{include/i-valid.i}*/

      if not frame {&frame-name}:validate() then 
         return 'ADM-ERROR':U.
      
      find first item where 
         item.it-codigo = item-lista-compon.es-codigo:screen-value in frame {&frame-name} no-lock no-error.
      if not avail item then do:   
          {utp/ut-table.i mgind item 01}       
          run utp/ut-msgs.p (input "show":U, 
                             input 56, 
                             input return-value).
          apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.                                
      else if item.un <> c-un:screen-value in frame {&frame-name} then do:
           run utp/ut-msgs.p (input "show":U, input 848, input "").
           apply 'entry' to c-un.
           return 'ADM-ERROR':U.
      end.
      /*else if item.politica = 5 then do:
           run utp/ut-msgs.p (input "show":U, input 25482, input "").
           return 'ADM-ERROR':U.
      end.*/
      
      if item.it-codigo = "" then do:
          run utp/ut-msgs.p (input "show",
                             input 17485,
                             input return-value).
          apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.                            
          return 'ADM-ERROR':U.
      end.   
 
      /*** Verifica se componente da estrutura ‚ obsoleto ***/
      if item.cod-obsoleto >= 3 then do:
          run utp/ut-msgs.p (input "show",
                             input 563,
                             input item.it-codigo).
          apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.                            
          return 'ADM-ERROR':U.
      end.         

      assign da-1 = date(item-lista-compon.data-inicio:screen-value in frame {&frame-name})
             da-2 = date(item-lista-compon.data-termino:screen-value in frame {&frame-name}).

      /*** Verifica coerˆncia de datas ***/
      if  da-1 > da-2 then do:
          {utp/ut-field.i mgind item-lista-compon data-termino 01}
          assign c-texto = return-value. 
          {utp/ut-field.i mgind item-lista-compon data-inicio 01}
          run utp/ut-msgs.p (input "show",
                             input 7017,
                             input c-texto + "~~" + return-value).
          apply 'entry' to item-lista-compon.data-inicio in frame {&frame-name}.                            
          return 'ADM-ERROR':U.
      end.         
      
      if item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes and
         input frame {&frame-name} item-lista-compon.cod-ref-es <> "" then do:
          find first ref-item
               where ref-item.cod-refer = input frame {&frame-name} item-lista-compon.cod-ref-es
                 and ref-item.it-codigo = input frame {&frame-name} item-lista-compon.es-codigo
               no-lock no-error.
          if not avail ref-item then do:
              {utp/ut-table.i mgind ref-item 01}
              run utp/ut-msgs.p (input 'show',
                                 input 56,
                                 input return-value).
              apply 'entry' to item-lista-compon.cod-ref-es in frame {&frame-name}.
              return 'ADM-ERROR':U.                               
          end.
      end.       
      else do:
          if item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes and
             input frame {&frame-name} item-lista-compon.cod-ref-es = "" then do:
  
            {utp/ut-table.i mgind ref-item 01}
            run utp/ut-msgs.p (input 'show',
                               input 56,
                               input return-value).
            apply 'entry' to item-lista-compon.cod-ref-es in frame {&frame-name}.
            return 'ADM-ERROR':U.                               
         end.
      end.
      
      if adm-new-record then do:

         find first b-item-lista-compon
              where b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name}
                and b-item-lista-compon.es-codigo        = item-lista-compon.es-codigo:screen-value in frame {&frame-name}
                &IF DEFINED (bf_man_204) &THEN   
                and b-item-lista-compon.sequencia        = int(item-lista-compon.sequencia:screen-value in frame {&frame-name})
                &ENDIF
                and rowid(b-item-lista-compon)          <> rowid(item-lista-compon) no-lock no-error.
         if avail b-item-lista-compon then do:

            {utp/ut-table.i mgind item-lista-compon 01}
            run utp/ut-msgs.p (input "show",
                               input 1,
                               input return-value).
            apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.
            return 'ADM-ERROR':U.
         end.     
    
      end.

	  /** Alteração ticket DMANFACTORY01-2478 **/
      /*if item-lista-compon.log-compon-altern:checked in frame {&frame-name} and
         item.tipo-con-est = 3 then do:
          run utp/ut-msgs.p (input 'show',
                             input 18233,
                             input return-value).
          apply 'entry' to item-lista-compon.log-compon-altern in frame {&frame-name}.
          return 'ADM-ERROR':U.        
      end.*/
            
    &IF DEFINED (bf_man_per_ppm) &THEN
        if param-global.modulo-per-ppm then do:

            if input frame {&frame-name} item-lista-compon.qtd-compon < 0 and
               item.tipo-formula >= 2 and
               item.tipo-formula <= 4 then do:
                run utp/ut-msgs.p (input "show",
                                   input 27296,
                                   input {ininc/i25in172.i 04 item.tipo-formula}).
                apply 'entry' to item-lista-compon.qtd-compon in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.

            IF item.tipo-formula = 4 THEN DO:
                /*Percentual deve ser diferente de zero.*/
                if tg-veiculo:CHECKED IN FRAME f-main AND
                   INPUT FRAME f-main fi-per-ppm <= 0 OR INPUT FRAME f-main fi-per-ppm = ? then do:
                    {utp/ut-liter.i %_Distrib._Ve¡culo *}
                    run utp/ut-msgs.p (input "show",
                                       input 2333,
                                       input RETURN-VALUE). 
                    apply "entry" to fi-per-ppm in frame {&frame-name}.
                    return "adm-error":u.
                end.
    
            END.
            
            if tg-veiculo:checked in frame {&frame-name} and
               can-find (first altern-lista-compon where
                               altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} and
                               altern-lista-compon.es-codigo        = item-lista-compon.es-codigo:screen-value in frame {&frame-name}) then do:
                
                for first altern-lista-compon no-lock where
                          altern-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} and
                          altern-lista-compon.es-codigo        = item-lista-compon.es-codigo:screen-value in frame {&frame-name},
                    first b-item no-lock where
                          b-item.it-codigo     = altern-lista-compon.al-codigo and
                          b-item.tipo-formula <> 4:

                    run utp/ut-msgs.p (input "show",
                                       input 27330,
                                       input altern-lista-compon.es-codigo + "~~" + 
                                             altern-lista-compon.cod-lista-compon).
                    apply 'entry' to item-lista-compon.qtd-compon in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                
                end.

            end.
                           
            assign tg-veiculo = tg-veiculo:checked in frame {&frame-name}
                   fi-per-ppm = INPUT FRAME f-main fi-per-ppm.

        end.    
    &ENDIF 
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    &IF DEFINED (bf_man_per_ppm) &THEN
        if param-global.modulo-per-ppm then
            assign item-lista-compon.veiculo = tg-veiculo:checked in frame {&frame-name}.
    &ENDIF
    
    IF item-lista-compon.fantasma THEN
        IF CAN-FIND (FIRST lista-compon-item
                   WHERE lista-compon-item.it-codigo = item-lista-compon.es-codigo NO-LOCK) THEN DO:
            run utp/ut-msgs.p (input "show",
                               INPUT 17755,
                               input RETURN-VALUE). 
            ASSIGN item-lista-compon.fantasma = NO.
            return "adm-error":u.
        END.

    run AtualizarItemListaCompon in h-boin479 (input rowid(item-lista-compon)).

    &IF DEFINED (bf_man_per_ppm) &THEN
          if param-global.modulo-per-ppm THEN DO:
    
              FOR EACH tt-datas:  DELETE tt-datas. END.
              FOR EACH tt-estruts: DELETE tt-estruts. END.
    
              IF item-lista-compon.veiculo THEN DO:
                  /*Tratamento de Grava‡Æo do Percentual de Distribui‡Æo do Ve¡culo*/
                  ASSIGN &IF DEFINED(bf_man_207A) &THEN                        
                             item-lista-compon.val-perc-distrib-veic = fi-per-ppm.                  
                         &ELSE   
                             item-lista-compon.char-1              = (if item-lista-compon.char-1 = ? then "" else item-lista-compon.char-1)
                             OVERLAY(item-lista-compon.char-1,6,7) = STRING(INT(fi-per-ppm * 10000)).
                         &ENDIF
                         
                  IF can-find (first b-item-lista-compon NO-LOCK
                               WHERE b-item-lista-compon.cod-lista-compon =  item-lista-compon.cod-lista-compon 
                                 and b-item-lista-compon.veiculo          =  true                
                                 and rowid(b-item-lista-compon)           <> rowid(item-lista-compon)) then DO:
                      /*caso exista mais de um componente na item-lista-compon usando este ve¡culo,
                        emite warning avisando que o usu rio dever  ajustar os percentuais em questÆo.*/
                      FOR EACH b-item-lista-compon NO-LOCK
                         WHERE b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon 
                           and b-item-lista-compon.veiculo          = TRUE
                           AND b-item-lista-compon.data-termino     > TODAY:
                          CREATE tt-datas.
                          ASSIGN tt-datas.dt-trans = b-item-lista-compon.data-inicio.
                          CREATE tt-datas.
                          ASSIGN tt-datas.dt-trans = b-item-lista-compon.data-termino - 1.
                      END.
    
                      FOR EACH tt-datas:
                          FOR EACH b-item-lista-compon NO-LOCK
                             WHERE b-item-lista-compon.cod-lista-compon =  item-lista-compon.cod-lista-compon 
                               and b-item-lista-compon.veiculo          =  TRUE
                               AND b-item-lista-compon.data-inicio      <= tt-datas.dt-trans
                               AND b-item-lista-compon.data-termino     >  tt-datas.dt-trans:
    
                              FIND FIRST tt-estruts 
                                   WHERE tt-estruts.sequencia = b-item-lista-compon.sequencia
                                     AND tt-estruts.es-codigo = b-item-lista-compon.es-codigo
                                     AND tt-estruts.dt-trans  = tt-datas.dt-trans NO-ERROR.
                              IF NOT AVAIL tt-estruts THEN DO:
                                  CREATE tt-estruts.
                                  ASSIGN tt-estruts.perc      = &IF DEFINED(bf_man_207A) &THEN                      
                                                                    b-item-lista-compon.val-perc-distrib-veic               
                                                                &ELSE                                               
                                                                    DEC(SUBSTRING(b-item-lista-compon.char-1,6,7)) / 10000 
                                                                &ENDIF 
                                         tt-estruts.dt-trans  = tt-datas.dt-trans       
                                         tt-estruts.sequencia = b-item-lista-compon.sequencia 
                                         tt-estruts.es-codigo = b-item-lista-compon.es-codigo.
                              END.
                              ASSIGN tt-datas.de-soma-perc = tt-datas.de-soma-perc + tt-estruts.perc.
                          END.
                      END.
    
                      FOR EACH tt-datas WHERE tt-datas.de-soma-perc = 100:
                          FOR EACH tt-estruts 
                             WHERE tt-estruts.dt-trans = tt-datas.dt-trans:
                              DELETE tt-estruts.
                          END.
                          DELETE tt-datas.
                      END.

                      IF CAN-FIND(FIRST tt-datas
                                  WHERE tt-datas.dt-trans >= item-lista-compon.data-inicio
                                    AND tt-datas.dt-trans <= item-lista-compon.data-termino) THEN DO:
    
                          FOR EACH tt-estruts:
                              FOR EACH  bf-tt-estruts
                                  WHERE bf-tt-estruts.sequencia =  tt-estruts.sequencia
                                    AND bf-tt-estruts.es-codigo =  tt-estruts.es-codigo
                                    AND ROWID(bf-tt-estruts)    <> ROWID(tt-estruts):
                                  DELETE bf-tt-estruts.
                              END.
                          END.
        
                          FOR EACH tt-estruts:
                              ASSIGN c-componentes = c-componentes +                                                                                     
                                     STRING(tt-estruts.sequencia) + " / ":U + STRING(tt-estruts.es-codigo) + ": ":U + STRING(tt-estruts.perc) + "%" + CHR(13). 
                          END.
        
                          IF c-componentes <> "":U THEN DO:
                              {utp/ut-liter.i Lista_de_Componentes *}
                              run utp/ut-msgs.p (input "show":U, input 33942, input c-componentes + "~~":U + RETURN-VALUE).
                          END.

                      END.
    
    
                  END. /*IF can-find (first b-item-lista-compon*/
              END.
              ELSE
                  ASSIGN &IF DEFINED(bf_man_207A) &THEN                                        
                             item-lista-compon.val-perc-distrib-veic = 0.                      
                         &ELSE                                                                 
                             item-lista-compon.char-1              = (if item-lista-compon.char-1 = ? then "" else item-lista-compon.char-1)
                             OVERLAY(item-lista-compon.char-1,6,7) = "":U. 
                         &ENDIF    
          END.
      &ENDIF
      
      IF ITEM.tipo-con-est = 4 THEN
          FOR EACH lista-compon-item WHERE
              lista-compon-item.cod-lista-compon = item-lista-compon.cod-lista-compon NO-LOCK:
              FOR EACH ref-estrut WHERE
                  ref-estrut.it-codigo = lista-compon-item.it-codigo AND
                  ref-estrut.es-codigo = item-lista-compon.es-codigo EXCLUSIVE-LOCK:
                  ASSIGN ref-estrut.cod-ref-es = item-lista-compon.cod-ref-es.
              END.
          END.
      
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

  if available lista-compon  then 
      assign item-lista-compon.cod-lista-compon = lista-compon.cod-lista-compon.
  
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
  /* Code placed here will execute AFTER standard behavior.    */
  
  {utp/ut-liter.i Reciclado_Lista} 
  ASSIGN item-lista-compon.log-compon-altern:LABEL in frame {&frame-name} = return-value.

  find lista-compon where rowid(lista-compon) = rw-lista no-lock no-error.
  if available lista-compon  then do:
      assign item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} = lista-compon.cod-lista-compon
             c-desc-lista:screen-value in frame {&frame-name}                       = lista-compon.des-lista-compon
             c-un-lista:screen-value in frame {&frame-name}                         = lista-compon.un.
     find item where item.it-codigo = item-lista-compon.es-codigo no-lock no-error.
     if  avail item then 
         assign c-un:screen-value in frame {&frame-name}    = item.un
                c-desc1:screen-value in frame {&frame-name} = item.desc-item.
     if adm-new-record then
        assign item-lista-compon.qtd-lista:screen-value in frame {&frame-name} = string(lista-compon.qtd-lista).

  end.
     
  if not adm-new-record and available item-lista-compon then do:
     
    &IF DEFINED(bf_man_per_ppm) &THEN
       find first item no-lock where
                  item.it-codigo = item-lista-compon.es-codigo no-error.
       if param-global.modulo-per-ppm and
          avail item then do:

           ASSIGN tg-veiculo:visible   in frame {&frame-name} = FALSE 
                  tg-veiculo:sensitive in frame {&frame-name} = FALSE.
           case item.tipo-formula:
               when 2 then
                   run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
               when 3 then                
                   run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
               WHEN 4 THEN DO:

                   run pi-formata-campo (fi-per-ppm:handle, true, /*TRUE*/ FALSE,
                                         IF item-lista-compon.veiculo 
                                         THEN (
                                         &IF DEFINED(bf_man_207A) &THEN
                                             item-lista-compon.val-perc-distrib-veic
                                         &ELSE
                                             DEC(dec(SUBSTRING(item-lista-compon.char-1,6,7)) / 10000)
                                         &ENDIF
                                         ) ELSE 0 , "%":U, ">>9.9999":U).
                                         
                   assign tg-veiculo:visible   in frame {&frame-name} = true 
                          /*tg-veiculo:SENSITIVE in frame {&frame-name} = true */
                          tg-veiculo:checked   in frame {&frame-name} = item-lista-compon.veiculo. 
                                         
/*                    APPLY "value-changed":U TO tg-veiculo IN FRAME f-main. */
    
               END.
               otherwise
                   run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
           end case.
       
       end.
    &ENDIF     
     
  end.
  
  
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
    /*run get-attribute ('adm-new-record').*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    /*if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
  if not adm-new-record then  do:
     find item where item.it-codigo = item-lista-compon.es-codigo no-lock no-error.
     if  avail item then do:
         assign c-un:screen-value in frame {&frame-name}    = item.un
                c-desc1:screen-value in frame {&frame-name} = item.desc-item.
         if item.tipo-con-est = 4 then
            assign item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes.
            
        &IF DEFINED (bf_man_per_ppm) &THEN
           if param-global.modulo-per-ppm then do:
           
               /*Projeto Controle de Potˆncia - Permite incluir o item como ve¡culo em mais de uma estrutura.*/
/*                if item.tipo-formula = 4 then do:                                                                        */
/*                    if not can-find (first b-item-lista-compon where                                                     */
/*                                           b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon and */
/*                                           b-item-lista-compon.veiculo                                               and */
/*                                           rowid(b-item-lista-compon) <> rowid(item-lista-compon)) then                  */
/*                        assign item-lista-compon.fantasma:column in frame {&frame-name} = 51.00                          */
/*                               tg-veiculo:visible   in frame {&frame-name} = true                                        */
/*                               tg-veiculo:sensitive in frame {&frame-name} = true                                        */
/*                               tg-veiculo:checked   in frame {&frame-name} = item-lista-compon.veiculo.                  */
/*                    else                                                                                                 */
/*                        assign item-lista-compon.fantasma:column in frame {&frame-name} = 51.00                          */
/*                               tg-veiculo:visible   in frame {&frame-name} = true                                        */
/*                               tg-veiculo:sensitive in frame {&frame-name} = false                                       */
/*                               tg-veiculo:checked   in frame {&frame-name} = false.                                      */
/*                end.                                                                                                     */
/*                else                                                                                                     */
/*                    assign item-lista-compon.fantasma:column in frame {&frame-name} = 51.00                              */
/*                           tg-veiculo:checked in frame {&frame-name} = false                                             */
/*                           tg-veiculo:visible in frame {&frame-name} = false.                                            */
               
               case item.tipo-formula:
                   when 2 then
                       run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                   when 3 then                
                       run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                   WHEN 4 THEN DO:

                       run pi-formata-campo (fi-per-ppm:handle, true, TRUE, 
                                             &IF DEFINED(bf_man_207A) &THEN
                                                 item-lista-compon.val-perc-distrib-veic
                                             &ELSE
                                                 DEC(dec(SUBSTRING(item-lista-compon.char-1,6,7)) / 10000)
                                             &ENDIF, "%":U, ">>9.9999":U).
                                             
                       assign tg-veiculo:visible   in frame {&frame-name} = true 
                              tg-veiculo:SENSITIVE in frame {&frame-name} = true 
                              tg-veiculo:checked   in frame {&frame-name} = item-lista-compon.veiculo. 
                                             
                       APPLY "value-changed":U TO tg-veiculo IN FRAME f-main.

                   END.
                   otherwise
                       run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
               end case.
           
           end.
        &ENDIF
            
     end.

     assign item-lista-compon.qtd-compon:screen-value in frame {&frame-name} = string(item-lista-compon.qtd-compon).

     ASSIGN qt-liquida:screen-value in frame {&frame-name} = STRING((item-lista-compon.qtd-compon) - 
                                                                   ((item-lista-compon.qtd-compon) * 
                                                                   ((item-lista-compon.fator-perda) / 100))).
     
     if  item-lista-compon.log-quant-fix:checked in frame {&frame-name} = YES THEN DO:
        assign  item-lista-compon.proporcao:SENSITIVE = FALSE
                item-lista-compon.fator-perda:SENSITIVE = FALSE
                qt-liquida:SENSITIVE = FALSE.
     END.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  find first param-global no-lock.
  assign /*item-lista-compon.fantasma:column in frame {&frame-name} = 51.00*/
         tg-veiculo:visible in frame {&frame-name} = false
         fi-per-ppm:visible in frame {&frame-name} = false.
  
  find lista-compon where rowid(lista-compon) = v-row-parent no-lock no-error.
  if not avail lista-compon then do:
     {utp/ut-table.i mgind lista-compon 1} 
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return 'ADM-ERROR':U.
  end. 
  assign rw-lista = v-row-parent.


    ASSIGN h-campo = item-lista-compon.qtd-compon:HANDLE.
    IF  h-campo:NAME = "qtd-compon" THEN DO:
        ASSIGN  h-campo:FORMAT = "->>>,>>9.9999999999".
    END.
    
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-hbo V-table-Win 
PROCEDURE pi-atualiza-hbo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle as handle no-undo.

assign h-boin479 = p-handle.

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

    if pVisible THEN DO:
        RUN utp/ut-liter.p (trim(pLabel), "*", "").
        assign pHandle:visible      = pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = string(pScreenValue)
               pHandle:label        = RETURN-VALUE no-error.
    END.
    else
        assign pHandle:visible = pVisible no-error.
    
return 'ok':u.

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
  {src/adm/template/snd-list.i "item-lista-compon"}

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


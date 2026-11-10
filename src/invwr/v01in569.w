&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V01IN569 2.00.00.032 } /*** "010032" 23/04/2025 08:54:21 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in569 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
def new global shared var i-ordem like oper-ord.nr-ord-produ no-undo.
def new global shared var c-it-codigo like oper-ord.it-codigo no-undo.
def new global shared var gr-ord-prod as rowid no-undo.
def new global shared var gr-ord-manut as rowid no-undo.
def new global shared var gr-estabelec as rowid no-undo. 
{cpp/cpapi005.i}
{cdp/cd0666.i}
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}
 
def var da-dt-retorno as date no-undo.

&if "{&bf_mat_versao_ems}" >= "2.062" &then

    {mnbo/bomn161.i1} /* tt-Utiliza */
    {method/dbotterr.i} /* rowerrors */
    
    def var p-cd-tecnico-ant as char init ""  no-undo.
    def var l-ok             as log  init yes no-undo.
    def var l-interf-util    as log  init no  no-undo.

    def new global shared var h-bomn161 as handle no-undo.

&endif

{cdp/cdunif001.i}

def var dt-trans as date no-undo.

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
&Scoped-define EXTERNAL-TABLES movto-ggf
&Scoped-define FIRST-EXTERNAL-TABLE movto-ggf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-ggf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS fi-nro-docto fi-serie-docto fi-it-codigo ~
c-desc-item fi-op-codigo c-desc-oper fi-cod-roteiro c-desc-roteiro ~
fi-cd-tecnico fi-desc-tec fi-cd-tarefa c-desc-tarefa fi-gm-codigo ~
c-desc-maq fi-cc-codigo c-desc-cc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,ord-manut,ord-prod,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi-nro-docto fi-serie-docto fi-it-codigo 
&Scoped-define ADM-ASSIGN-FIELDS fi-nro-docto fi-serie-docto fi-it-codigo ~
fi-op-codigo fi-cod-roteiro fi-cd-tecnico fi-cd-tarefa fi-gm-codigo ~
fi-cc-codigo 
&Scoped-define ord-manut fi-cd-tecnico fi-cd-tarefa fi-cc-codigo 
&Scoped-define ord-prod fi-op-codigo fi-cod-roteiro fi-gm-codigo ~
fi-cc-codigo 

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
DEFINE VARIABLE c-desc-cc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-maq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-oper AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-roteiro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tarefa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo":R15 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88.

DEFINE VARIABLE fi-cd-tarefa AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Tarefa Manutená∆o" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-tecnico AS CHARACTER FORMAT "99999-9":U 
     LABEL "TÇcnico" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-roteiro AS CHARACTER FORMAT "x(16)" 
     LABEL "Roteiro":R9 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88.

DEFINE VARIABLE fi-desc-tec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gm-codigo AS CHARACTER FORMAT "x(9)" 
     LABEL "Grupo M†quina":R16 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item Mob":R10 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88.

DEFINE VARIABLE fi-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88.

DEFINE VARIABLE fi-op-codigo AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Operaá∆o":R10 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .88.

DEFINE VARIABLE fi-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "":R18 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 8.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-nro-docto AT ROW 1.25 COL 19.43 COLON-ALIGNED
     fi-serie-docto AT ROW 1.25 COL 72.29 COLON-ALIGNED HELP
          "SÇrie do Documento"
     fi-it-codigo AT ROW 2.25 COL 19.43 COLON-ALIGNED HELP
          "C¢digo do Item da Ordem"
     c-desc-item AT ROW 2.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-op-codigo AT ROW 3.25 COL 19.43 COLON-ALIGNED
     c-desc-oper AT ROW 3.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cod-roteiro AT ROW 4.25 COL 19.43 COLON-ALIGNED
     c-desc-roteiro AT ROW 4.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cd-tecnico AT ROW 5.25 COL 19.43 COLON-ALIGNED
     fi-desc-tec AT ROW 5.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cd-tarefa AT ROW 6.25 COL 19.43 COLON-ALIGNED
     c-desc-tarefa AT ROW 6.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-gm-codigo AT ROW 7.25 COL 19.43 COLON-ALIGNED
     c-desc-maq AT ROW 7.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cc-codigo AT ROW 8.25 COL 19.43 COLON-ALIGNED HELP
          "Centro de Custo"
     c-desc-cc AT ROW 8.25 COL 40.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-ggf
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
         HEIGHT             = 8.42
         WIDTH              = 83.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-cc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-maq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-oper IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-roteiro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tarefa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cc-codigo IN FRAME f-main
   NO-ENABLE 2 4 5                                                      */
/* SETTINGS FOR FILL-IN fi-cd-tarefa IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-cd-tecnico IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR FILL-IN fi-cod-roteiro IN FRAME f-main
   NO-ENABLE 2 5                                                        */
/* SETTINGS FOR FILL-IN fi-desc-tec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-gm-codigo IN FRAME f-main
   NO-ENABLE 2 5                                                        */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-nro-docto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-op-codigo IN FRAME f-main
   NO-ENABLE 2 5                                                        */
/* SETTINGS FOR FILL-IN fi-serie-docto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME fi-cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON ENTRY OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
    assign fi-cc-codigo:format in frame {&frame-name} = 'x(20)'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON F5 OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  
   &IF DEFINED (bf_man_linha_estab) &THEN
       find first estabelec
            where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
       if avail estabelec then
          assign gr-estabelec = rowid(estabelec).
   &ENDIF  

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:
    
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
    
        RUN pi_zoom_ccusto IN h_api_ccusto (INPUT "",                  /* EMPRESA EMS2 */
                                            INPUT "",                  /* CODIGO DO PLANO CCUSTO */
                                            INPUT "",                  /* UNIDADE DE NEGOCIO */
                                            INPUT TODAY,               /* DATA DE TRANSACAO */
                                            OUTPUT v_cod_ccusto,       /* CODIGO CCUSTO */
                                            OUTPUT v_des_ccusto,       /* DESCRICAO CCUSTO */
                                            OUTPUT TABLE tt_log_erro). /* ERROS */
    
        ASSIGN fi-cc-codigo:SCREEN-VALUE IN FRAME {&frame-name} = v_cod_ccusto
               c-desc-cc:SCREEN-VALUE IN FRAME {&frame-name}    = v_des_ccusto.
    
        if valid-handle(h_api_ccusto) then
            delete object h_api_ccusto.
    
    END.
    ELSE DO:
        /** Utilizar Centro de Custo Produtivo **/
        {include/zoomvar.i &prog-zoom="inzoom/z01in042.w"
                           &campo=fi-cc-codigo
                           &campo2=c-desc-cc
                           &campozoom=cc-codigo
                           &campozoom2=descricao}
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON LEAVE OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
    assign fi-cc-codigo:format in frame {&frame-name} = 'x(20)'.

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:
   
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

        run pi_retorna_formato_ccusto in h_api_ccusto (input  "",                   /* EMPRESA EMS2 */
                                                       input  "",                   /* PLANO CCUSTO */
                                                       input  TODAY,                /* DATA DE TRANSACAO */
                                                       output p_cod_format_ccusto,  /* FORMATO CCUSTO */
                                                       output table tt_log_erro).   /* ERROS */ 

        IF (input frame {&frame-name} fi-cc-codigo <> ""
        AND LENGTH(REPLACE(p_cod_format_ccusto,".","")) = LENGTH(input frame {&frame-name} fi-cc-codigo))
        THEN DO:
            assign fi-cc-codigo:FORMAT IN FRAME {&frame-name} = p_cod_format_ccusto.
        END.

        run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                   INPUT "",
                                                   INPUT input frame {&frame-name} fi-cc-codigo,
                                                   INPUT today,
                                                   OUTPUT v_des_ccusto,
                                                   OUTPUT TABLE tt_log_erro).

        assign c-desc-cc:screen-value in frame {&frame-name} = v_des_ccusto.

        if valid-handle(h_api_ccusto) then
            delete object h_api_ccusto.

    END.
    ELSE DO:
        {include/leave.i
                &tabela=centro-custo
                &atributo-ref=descricao
                &variavel-ref=c-desc-cc
                &where="centro-custo.cc-codigo = input frame {&frame-name} fi-cc-codigo"}
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-tarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tarefa V-table-Win
ON F5 OF fi-cd-tarefa IN FRAME f-main /* Tarefa Manutená∆o */
DO:
  assign gr-ord-manut = rowid(ord-manut).
  {include/zoomvar.i &prog-zoom  = "inzoom/z01in273.w"
                     &campo      = fi-cd-tarefa
                     &campozoom  = cd-tarefa
                     &campo2     = c-desc-tarefa
                     &campozoom2 = descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tarefa V-table-Win
ON LEAVE OF fi-cd-tarefa IN FRAME f-main /* Tarefa Manutená∆o */
DO:
   {include/leave.i
            &tabela=ord-taref
            &atributo-ref=descricao
            &variavel-ref=c-desc-tarefa
            &where="ord-taref.nr-ord-produ = ord-prod.nr-ord-produ and
                    ord-taref.cd-tarefa = input frame {&frame-name} fi-cd-tarefa"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tarefa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-tarefa IN FRAME f-main /* Tarefa Manutená∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-tecnico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tecnico V-table-Win
ON F5 OF fi-cd-tecnico IN FRAME f-main /* TÇcnico */
DO:
  {include/zoomvar.i &prog-zoom  = "inzoom/z01in428.w"
                     &campo      = fi-cd-tecnico
                     &campozoom  = cd-tecnico
                     &campo2     = fi-desc-tec
                     &campozoom2 = nome-compl}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tecnico V-table-Win
ON LEAVE OF fi-cd-tecnico IN FRAME f-main /* TÇcnico */
DO:
    {cdp/cd9998.i}
    {include/leave.i
            &tabela=tecn-mi
            &variavel-ref=fi-desc-tec
            &atributo-ref=nome-compl
            &where="tecn-mi.cd-tecnico = input frame {&frame-name} fi-cd-tecnico"}
   if fi-cd-tecnico <> input frame {&frame-name} fi-cd-tecnico then do:
      assign fi-cd-tecnico.
      find tecn-mi where 
           tecn-mi.cd-tecnico = input frame {&frame-name} fi-cd-tecnico 
           no-lock no-error.
      if avail tecn-mi then do:
         find equipto where
              equipto.cd-equipto = ord-manut.cd-equipto 
              no-lock no-error.         
         assign fi-gm-codigo = (if avail equipto then
                                   equipto.gm-codigo
                                else "").      
         assign fi-cc-codigo = tecn-mi.cc-codigo.
         assign fi-cc-codigo:sensitive    in frame {&frame-name} = no.
         disp fi-gm-codigo
              fi-cc-codigo with frame {&frame-name}.

         IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:

            if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

            run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT tecn-mi.cc-codigo,
                                                       INPUT today,
                                                       OUTPUT v_des_ccusto,
                                                       OUTPUT TABLE tt_log_erro).

         END.
         ELSE DO:
             find FIRST centro-custo 
                   where centro-custo.cc-codigo = fi-cc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock no-error.
             if avail(centro-custo) then 
                 ASSIGN v_des_ccusto = centro-custo.descricao.
             
         END.

         assign c-desc-cc:screen-value in frame {&frame-name} = v_des_ccusto.

      end.
      else 
          assign fi-desc-tec:screen-value in frame {&frame-name}  = ""
                 fi-gm-codigo:screen-value in frame {&frame-name} = ""
                 fi-gm-codigo                                     = "". 
   end.
   
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tecnico V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-tecnico IN FRAME f-main /* TÇcnico */
DO:
  Apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON F5 OF fi-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = fi-op-codigo
                     &campozoom  = op-codigo
                     &campo2     = fi-cod-roteiro
                     &campozoom2 = cod-roteiro
                     &campo3     = fi-it-codigo
                     &campozoom3 = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON LEAVE OF fi-cod-roteiro IN FRAME f-main /* Roteiro */
DO:  
  {include/leave.i &tabela=rot-fabric
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-roteiro
                   &where="rot-fabric.cod-roteiro = input frame {&frame-name} fi-cod-roteiro"}
   if fi-cod-roteiro <> fi-cod-roteiro:screen-value in frame {&frame-name} then do:
      assign fi-cod-roteiro.
      run pi-leave-op-codigo.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-gm-codigo V-table-Win
ON F5 OF fi-gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in144.w"
                       &campo=fi-gm-codigo
                       &campo2=c-desc-maq
                       &campozoom=gm-codigo
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-gm-codigo V-table-Win
ON LEAVE OF fi-gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
   {include/leave.i
            &tabela=grup-maquina
            &atributo-ref=descricao
            &variavel-ref=c-desc-maq
            &where="grup-maquina.gm-codigo = input frame {&frame-name} fi-gm-codigo"}
    
    if fi-gm-codigo <> fi-gm-codigo:screen-value in frame {&frame-name} then do:
 
       assign fi-gm-codigo.  
       
    
       &IF DEFINED (bf_man_linha_estab) &THEN
                  
           find first gm-estab
                where gm-estab.gm-codigo   = input  fi-gm-codigo
                  and gm-estab.cod-estabel = ord-prod.cod-estabel no-lock no-error.
          
                                
           if not avail gm-estab then
              find first gm-estab
                   where gm-estab.gm-codigo = input fi-gm-codigo
                   and   gm-estab.cod-estabel = "*" no-lock no-error.
                   
          
           if avail gm-estab then do :

               IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:
                   if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

                   run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                              INPUT "",
                                                              INPUT gm-estab.cc-codigo,
                                                              INPUT today,
                                                              OUTPUT v_des_ccusto,
                                                              OUTPUT TABLE tt_log_erro).
          
                   

               END.
               ELSE DO:
                   FIND FIRST centro-custo NO-LOCK
                        WHERE centro-custo.cc-codigo = gm-estab.cc-codigo NO-ERROR.
                   IF AVAILABLE centro-custo THEN
                       ASSIGN v_des_ccusto = centro-custo.descricao.
                       

               END.

               assign fi-cc-codigo:screen-value in frame {&frame-name} = gm-estab.cc-codigo
                      c-desc-cc:screen-value    in frame {&frame-name} = v_des_ccusto
                      fi-cc-codigo:sensitive    in frame {&frame-name} = no.
 
               apply 'leave' to fi-cc-codigo in frame {&frame-name}.

           end.
           else do:
               assign fi-cc-codigo:screen-value in frame {&frame-name} = ""
                      c-desc-cc:screen-value    in frame {&frame-name} = ""
                      fi-cc-codigo:sensitive    in frame {&frame-name} = yes.
                      apply 'entry' to fi-cc-codigo in frame {&frame-name}.
                      return no-apply.
           end.

       &ELSE 
           find grup-maquina where 
                grup-maquina.gm-codigo = input fi-gm-codigo
                no-lock no-error.
           if avail grup-maquina then do:

               IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:

                   if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

                   run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                              INPUT "",
                                                              INPUT gm-estab.cc-codigo,
                                                              INPUT today,
                                                              OUTPUT v_des_ccusto,
                                                              OUTPUT TABLE tt_log_erro).

               END.
               ELSE DO:
                   FIND FIRST centro-custo NO-LOCK
                        WHERE centro-custo.cc-codigo = gm-estab.cc-codigo NO-ERROR.
                   IF AVAILABLE centro-custo THEN
                       ASSIGN v_des_ccusto = centro-custo.descricao.
               END.

               assign fi-cc-codigo:screen-value in frame {&frame-name} = grup-maquina.cc-codigo
                      c-desc-cc:screen-value    in frame {&frame-name} = v_des_ccusto
                      fi-cc-codigo:sensitive    in frame {&frame-name} = no.

               apply 'leave' to fi-cc-codigo in frame {&frame-name}.

           end.
           else do:
              assign fi-cc-codigo:screen-value in frame {&frame-name} = ""
                     c-desc-cc:screen-value    in frame {&frame-name} = ""
                     fi-cc-codigo:sensitive    in frame {&frame-name} = yes.
              apply 'entry' to fi-cc-codigo in frame {&frame-name}.
              return no-apply.
           end.

       &ENDIF
       /************************/
    end.
        
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON F5 OF fi-it-codigo IN FRAME f-main /* Item Mob */
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z01in172.w"
                     &campo     = fi-it-codigo
                     &campozoom = it-codigo   }
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON LEAVE OF fi-it-codigo IN FRAME f-main /* Item Mob */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo = input frame {&frame-name} fi-it-codigo"}
  if fi-it-codigo <> fi-it-codigo:screen-value in frame {&frame-name} and
     not avail ord-manut then do:
     assign fi-it-codigo.                   
     run pi-leave-op-codigo.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME f-main /* Item Mob */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON F5 OF fi-op-codigo IN FRAME f-main /* Operaá∆o */
DO:
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = fi-op-codigo
                     &campozoom  = op-codigo
                     &campo2     = fi-cod-roteiro
                     &campozoom2 = cod-roteiro
                     &campo3     = fi-it-codigo
                     &campozoom3 = it-codigo}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON LEAVE OF fi-op-codigo IN FRAME f-main /* Operaá∆o */
DO: 
    {include/leave.i &tabela=oper-ord
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-oper
                     &where="oper-ord.nr-ord-produ = ord-prod.nr-ord-produ and
                             oper-ord.it-codigo    = input frame {&frame-name} fi-it-codigo and
                             oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo and
                             oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro"}
    if fi-op-codigo <> int (fi-op-codigo:screen-value in frame {&frame-name}) then do:
       assign fi-op-codigo.
       run pi-leave-op-codigo.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-op-codigo IN FRAME f-main /* Operaá∆o */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 

if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

  /************************ INTERNAL PROCEDURES ********************/
do with frame {&frame-name}:
   if fi-it-codigo:load-mouse-pointer   ("Image~\lupa.cur") then.
   if fi-op-codigo:load-mouse-pointer   ("Image~\lupa.cur") then.
   if fi-cod-roteiro:load-mouse-pointer ("Image~\lupa.cur") then.
   if fi-gm-codigo:load-mouse-pointer   ("Image~\lupa.cur") then.
   if fi-cc-codigo:load-mouse-pointer   ("Image~\lupa.cur") then.
   if fi-cd-tarefa:load-mouse-pointer   ("Image~\lupa.cur") then.
   if fi-cd-tecnico:load-mouse-pointer  ("Image~\lupa.cur") then.
   {utp/ut-field.i mgind movto-ggf nro-docto 1}
   assign fi-nro-docto:label = trim (return-value).
   {utp/ut-field.i mgind movto-ggf serie-docto 1}
   assign fi-serie-docto:label = trim (return-value).
   {utp/ut-field.i mgind movto-ggf it-codigo 1}
   assign fi-it-codigo:label = trim (return-value).
   {utp/ut-field.i mgind movto-ggf op-codigo 1}
   assign fi-op-codigo:label = trim (return-value).
   {utp/ut-field.i mgind movto-ggf cod-roteiro 1}
   assign fi-cod-roteiro:label = trim (return-value).
   {utp/ut-field.i mgind movto-ggf gm-codigo 1}
   assign fi-gm-codigo:label = trim (return-value).
   {utp/ut-field.i mgind movto-ggf cc-codigo 1}
   assign fi-cc-codigo:label  = trim (return-value).
   {utp/ut-field.i mgind ord-taref cd-tarefa 1}
   assign fi-cd-tarefa:label = trim (return-value).
   {utp/ut-field.i mgind ord-taref cd-tecnico 1}
   assign fi-cd-tecnico:label  = trim (return-value).
end.

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
  {src/adm/template/row-list.i "movto-ggf"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-ggf"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.
 
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
 
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
  find ord-prod  where 
       rowid(ord-prod) = gr-ord-prod 
       no-lock no-error.
  find ord-manut where 
       ord-manut.nr-ord-produ = ord-prod.nr-ord-produ 
       no-lock no-error.
  run get-attribute in this-procedure ('adm-new-record').
  if return-value = 'yes' then do:
     assign fi-it-codigo = ord-prod.it-codigo.
     find item where 
          item.it-codigo = ord-prod.it-codigo
          no-lock no-error.
     assign c-desc-item = (if avail item then
                              item.desc-item
                           else "").
     disp fi-it-codigo
          fi-op-codigo
          fi-cod-roteiro
          c-desc-item with frame {&frame-name}.
     enable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
     if avail ord-manut then
        enable {&ord-manut} with frame {&frame-name}.        
     else do:
          enable {&ord-prod} with frame {&frame-name}.
          assign fi-gm-codigo:sensitive in frame {&frame-name} = (ord-prod.reporte-ggf = 1).
     end.
     
     run pi-leave-op-codigo.
     
     apply 'entry' to fi-nro-docto in frame {&frame-name}.
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

  /* Code placed here will execute AFTER standard behavior.    */

  &if "{&bf_mat_versao_ems}" >= "2.062" &then
    find first param-global no-lock no-error.
    if param-global.modulo-mi then do:
        find first param-mi no-lock no-error.
        if avail param-mi then
            assign l-interf-util = param-mi.log-interf-util.
    end.
  &endif

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
 
  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.
 
  if avail ord-prod then do:         
     if avail movto-ggf then do:
        assign fi-nro-docto    = movto-ggf.nro-docto
               fi-serie-docto  = movto-ggf.serie-docto
               fi-it-codigo    = movto-ggf.it-codigo
               fi-op-codigo    = movto-ggf.op-codigo
               fi-cod-roteiro  = movto-ggf.cod-roteiro
               fi-gm-codigo    = movto-ggf.gm-codigo
               fi-cc-codigo    = movto-ggf.cc-codigo
               fi-cd-tecnico   = movto-ggf.cd-tecnico
               fi-cd-tarefa    = movto-ggf.cd-tarefa.
               
            
                 
        find item where item.it-codigo = movto-ggf.it-codigo no-lock no-error.
        if avail item then  assign c-desc-item = item.desc-item.
        else   assign c-desc-item = "".
        find oper-ord where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                      and oper-ord.it-codigo    = movto-ggf.it-codigo
                      and oper-ord.op-codigo    = movto-ggf.op-codigo
                      and oper-ord.cod-roteiro  = movto-ggf.cod-roteiro
                      no-lock no-error.
        if avail oper-ord then  assign c-desc-oper = oper-ord.descricao.
        else  assign c-desc-oper = "".
        find grup-maquin where grup-maquin.gm-codigo = movto-ggf.gm-codigo
             no-lock no-error.
        if avail grup-maquin then  assign c-desc-maq = grup-maquin.descricao.
        else  assign c-desc-maq = "". 


        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:

            if not valid-handle(h_api_ccusto) then 
                run prgint/utb/utb742za.py persistent set h_api_ccusto.

            run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT movto-ggf.cc-codigo,
                                                       INPUT today,
                                                       OUTPUT v_des_ccusto,
                                                       OUTPUT TABLE tt_log_erro).

        END.
        ELSE DO:
            FIND FIRST centro-custo NO-LOCK
                 WHERE centro-custo.cc-codigo = movto-ggf.cc-codigo NO-ERROR.
            IF AVAILABLE centro-custo THEN
                ASSIGN v_des_ccusto = centro-custo.descricao.

        END.

        assign c-desc-cc = v_des_ccusto.


        find ord-taref where ord-taref.cd-tarefa = movto-ggf.cd-tarefa 
             and ord-taref.nr-ord-produ = ord-prod.nr-ord-produ
             no-lock no-error.
        if avail ord-taref then  assign c-desc-tarefa = ord-taref.descricao.
        else  assign c-desc-tarefa = "". 
        find tecn-mi where tecn-mi.cd-tecnico = movto-ggf.cd-tecnico
             no-lock no-error.
        if avail tecn-mi then  assign fi-desc-tec = tecn-mi.nome-compl.
        else  assign fi-desc-tec = "". 
 
        assign da-dt-retorno = movto-ggf.dt-trans.    
     end.
  end.
  
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
  run dispatch in this-procedure ('display-fields').
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-upc V-table-Win 
PROCEDURE pi-cria-upc :
/**********************************************************************
**
** UPC para Final da criacao do movto-ggf.
** 
**********************************************************************/ 

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF

/* DPC */
if  c-nom-prog-dpc-mg97 <> ""
and c-nom-prog-dpc-mg97 <> ? then do:

    run value(c-nom-prog-dpc-mg97) (input "ROWID-GGF", 
                                    input "BT-OK",
                                    input this-procedure,
                                    input frame f-main:handle,
                                    input "",
                                    input tt-movto-ggf.rw-movto-ggf).    

end.

/* APPC */
if  c-nom-prog-appc-mg97 <> ""
and c-nom-prog-appc-mg97 <> ? then do:           
    
    run value(c-nom-prog-appc-mg97) (input "CALC-END", 
                                     input "BT-OK",
                                     input this-procedure,
                                     input frame f-main:handle,
                                     input "",
                                     input tt-movto-ggf.rw-movto-ggf).    

end.                                       

/* UPC */
if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:

    run value(c-nom-prog-upc-mg97) (input "ROWID-GGF",
                                    input "BT-OK",
                                    input this-procedure,
                                    input frame f-main:handle,
                                    input "",
                                    input tt-movto-ggf.rw-movto-ggf).    

end.                                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-op-codigo V-table-Win 
PROCEDURE pi-leave-op-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first oper-ord 
         where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
           and oper-ord.it-codigo    = input frame {&frame-name} fi-it-codigo
           and oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo
           and oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro
           no-lock no-error.
    
    assign c-desc-oper:screen-value in frame {&frame-name} = (if avail oper-ord then
                                                                 oper-ord.descricao
                                                              else "").                 

   if input frame {&frame-name} fi-op-codigo <> 0 then do:
      if available(oper-ord) then do:
         if oper-ord.tipo-oper = 2 then do:          
            run utp/ut-msgs.p (input "show",
                               input 17474,
                               input "").
            return no-apply.
         end.           
         else do:
             assign fi-gm-codigo:sensitive    in frame {&frame-name} = (ord-prod.reporte-ggf = 1)
                    fi-gm-codigo                                     = oper-ord.gm-codigo
                    fi-gm-codigo:screen-value in frame {&frame-name} = oper-ord.gm-codigo.         



             &IF DEFINED (bf_man_linha_estab) &THEN
                        
                 find first gm-estab
                      where gm-estab.gm-codigo   = oper-ord.gm-codigo
                        and gm-estab.cod-estabel = ord-prod.cod-estabel no-lock no-error.
                
                 if not avail gm-estab then
                     find first gm-estab
                          where gm-estab.gm-codigo = oper-ord.gm-codigo
                            and gm-estab.cod-estabel = "*" no-lock no-error.
                        
                
                 if avail gm-estab then do :
                     assign fi-cc-codigo                                     = gm-estab.cc-codigo
                            fi-cc-codigo:screen-value in frame {&frame-name} = gm-estab.cc-codigo .
                     

                     IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:
                         if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

                         run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                                    INPUT "",
                                                                    INPUT gm-estab.cc-codigo,
                                                                    INPUT today,
                                                                    OUTPUT v_des_ccusto,
                                                                    OUTPUT TABLE tt_log_erro).          
                     END.
                     ELSE DO:
                         FIND FIRST centro-custo NO-LOCK
                              WHERE centro-custo.cc-codigo = gm-estab.cc-codigo NO-ERROR.
                         IF AVAILABLE centro-custo THEN
                             ASSIGN v_des_ccusto = centro-custo.descricao.

                     END.

                     find grup-maquina where grup-maquina.gm-codigo = oper-ord.gm-codigo no-lock no-error.
                     if avail grup-maquina THEN
                         assign  c-desc-maq:screen-value   in frame {&frame-name} = grup-maquina.descricao
                                 fi-cc-codigo:sensitive    in frame {&frame-name} = avail ord-manut
                                 c-desc-cc:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = v_des_ccusto.
                 end.
                 else
                     assign fi-cc-codigo                                     = ""
                            fi-cc-codigo:screen-value in frame {&frame-name} = ""
                            c-desc-maq:screen-value   in frame {&frame-name} = ""
                            fi-cc-codigo:sensitive    in frame {&frame-name} = yes.   

                 
              &ELSE 
                  find grup-maquina where 
                       grup-maquina.gm-codigo = oper-ord.gm-codigo no-lock no-error.
                  if avail grup-maquina then
                       assign fi-cc-codigo                                     = grup-maquina.cc-codigo
                              fi-cc-codigo:screen-value in frame {&frame-name} = grup-maquina.cc-codigo
                              c-desc-maq:screen-value   in frame {&frame-name} = grup-maquina.descricao
                              fi-cc-codigo:sensitive    in frame {&frame-name} = avail ord-manut.
                  ELSE assign fi-cc-codigo                                     = ""
                              fi-cc-codigo:screen-value in frame {&frame-name} = ""
                              c-desc-maq:screen-value   in frame {&frame-name} = ""
                              fi-cc-codigo:sensitive    in frame {&frame-name} = yes.                    
                
                  IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:

                      if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
                          run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                                     INPUT "",
                                                                     INPUT input frame {&frame-name} fi-cc-codigo,
                                                                     INPUT today,
                                                                     OUTPUT v_des_ccusto,
                                                                     OUTPUT TABLE tt_log_erro).
                  END.
                  ELSE DO:
                      FIND FIRST centro-custo NO-LOCK
                          WHERE centro-custo.cc-codigo = input frame {&frame-name} fi-cc-codigo NO-ERROR.
                      IF AVAILABLE centro-custo THEN
                          ASSIGN v_des_ccusto = centro-custo.descricao.
                  END.

                  assign c-desc-cc:screen-value in frame {&frame-name} = v_des_ccusto.
   
             &ENDIF
              
         end. /* else do */
      end.  /* avail oper-ord */
      else do:
           assign fi-gm-codigo:screen-value in frame {&frame-name} = ""
                  fi-gm-codigo                                     = ""
                  fi-cc-codigo:screen-value in frame {&frame-name} = ""
                  fi-cc-codigo                                     = ""
                  c-desc-maq:screen-value   in frame {&frame-name} = ""
                  c-desc-cc:screen-value    in frame {&frame-name} = ""
                  fi-gm-codigo:sensitive    in frame {&frame-name} = 
                  not can-find (first oper-ord 
                                where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod no-lock)
                  and input frame {&frame-name} fi-op-codigo = 0
                  fi-cc-codigo:sensitive    in frame {&frame-name} =
                  fi-gm-codigo:sensitive    in frame {&frame-name}.
      end.
   end.
   else do:
        assign fi-gm-codigo:screen-value in frame {&frame-name} = ""
               fi-gm-codigo                                     = ""
               fi-cc-codigo:screen-value in frame {&frame-name} = ""
               fi-cc-codigo                                     = ""
               c-desc-maq:screen-value   in frame {&frame-name} = ""
               c-desc-cc:screen-value    in frame {&frame-name} = ""
               fi-gm-codigo:sensitive    in frame {&frame-name} = yes 
               fi-cc-codigo:sensitive    in frame {&frame-name} = yes.
   end.
   
   if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-record V-table-Win 
PROCEDURE pi-update-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/i-vldfrm.i}
do with frame {&frame-name}:
     find item where  item.it-codigo = input fi-it-codigo  no-lock no-error.
     if not avail(item) then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p (input "show" ,
                           input 56 ,
                           input return-value).
        apply 'entry' to fi-it-codigo .                           
        return "adm-error".
     end. 
 
     if input fi-op-codigo > 0 or (input fi-gm-codigo = "" 
              and  input fi-cc-codigo = "") then do:

        if  avail ord-manut then do:
            find ord-taref where ord-taref.nr-ord-prod = ord-prod.nr-ord-produ 
                 and ord-taref.cd-tarefa   = input fi-cd-tarefa  no-lock no-error.
            if not avail(ord-taref) then do:
               {include/i-vldprg.i}
               {utp/ut-table.i mgind ord-taref 1}
               run utp/ut-msgs.p (input "show",
                                  input 56    ,
                                  input return-value).
               apply 'entry' to fi-op-codigo in frame {&frame-name}.
               return "adm-error".
            end.
         end.
         else do:
            if input fi-op-codigo <> 0 then do:
               find oper-ord where 
                    oper-ord.nr-ord-prod = ord-prod.nr-ord-produ  and
                    oper-ord.it-codigo   = input fi-it-codigo     and
                    oper-ord.op-codigo   = input fi-op-codigo     and
                    oper-ord.cod-roteiro = input fi-cod-roteiro         
                    no-lock no-error.
               if not avail(oper-ord) then do:
                  {include/i-vldprg.i}
                  {utp/ut-table.i mgind oper-ord 1}
                  run utp/ut-msgs.p (input "show",
                                     input 56    ,
                                     input return-value).
                  apply 'entry' to fi-op-codigo in frame {&frame-name}.
                  return "adm-error".
               end.
            end.
         end.
     end.
     if fi-gm-codigo:sensitive and input fi-gm-codigo <> "" then do:   
        find grup-maquina where grup-maquina.gm-codigo = input fi-gm-codigo   
             no-lock no-error.
        if not avail(grup-maquina) then do:
           {include/i-vldprg.i}
           {utp/ut-table.i mgind grup-maquina 1}
           run utp/ut-msgs.p (input "show",
                              input 56    ,   
                              input return-value).
           apply 'entry' to fi-gm-codigo in frame {&frame-name}.                              
           return "adm-error".
        end.
     end.
    
     if fi-cc-codigo:sensitive and input fi-cc-codigo <> "" then do:     
         IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-unif-cc-prod" AND funcao.ativo = yes) THEN DO:
             if not valid-handle(h_api_ccusto) then 
                 run prgint/utb/utb742za.py persistent set h_api_ccusto.

             run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                        INPUT "",
                                                        INPUT input frame {&frame-name} fi-cc-codigo,
                                                        INPUT today,
                                                        OUTPUT v_des_ccusto,
                                                        OUTPUT TABLE tt_log_erro). 

             IF CAN-FIND(FIRST tt_log_erro NO-LOCK) THEN DO:
                 {utp/ut-table.i mgind centro-custo 1}
                 run utp/ut-msgs.p (input "show"      ,
                                    input 56          ,   
                                    input return-value).
                 apply 'entry' to fi-cc-codigo in frame {&frame-name}.
                 return 'adm-error'.
             end.  

         END.
         ELSE DO:
             find FIRST centro-custo 
                  where centro-custo.cc-codigo = fi-cc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock no-error.
            if not avail(centro-custo) then do:
               {utp/ut-table.i mgind centro-custo 1}
               run utp/ut-msgs.p (input "show"      ,
                                  input 56          ,   
                                  input return-value).
               apply 'entry' to fi-cc-codigo in frame {&frame-name}.
               return 'adm-error'.
            end.   
         END.
     end.

     if fi-cd-tecnico:sensitive and input fi-cd-tecnico <> "" then do:   
        find tecn-mi where tecn-mi.cd-tecnico = input fi-cd-tecnico   
             no-lock no-error.
        if not avail(tecn-mi) then do:
           {include/i-vldprg.i}
           {utp/ut-table.i mgind tecn-mi 1}
           run utp/ut-msgs.p (input "show",
                              input 56    ,   
                              input return-value).
           apply 'entry' to fi-cd-tecnico in frame {&frame-name}.                              
           return "adm-error".
        end.
     end.

     for each tt-movto-ggf:
         delete tt-movto-ggf.
     end.
 
     create tt-movto-ggf.
    
     run get-attribute ('adm-new-record').  
     assign tt-movto-ggf.cod-versao-integracao = 1
            tt-movto-ggf.nr-ord-produ          = ord-prod.nr-ord-produ
            tt-movto-ggf.cod-estabel           = ord-prod.cod-estabel
            tt-movto-ggf.nro-docto             = input fi-nro-docto
            tt-movto-ggf.serie-docto           = input fi-serie-docto
            tt-movto-ggf.qt-reportada          = 0
            tt-movto-ggf.it-codigo             = input fi-it-codigo
            tt-movto-ggf.op-codigo             = input fi-op-codigo
            tt-movto-ggf.cc-codigo             = input fi-cc-codigo
            tt-movto-ggf.cod-roteiro           = input fi-cod-roteiro
            tt-movto-ggf.gm-codigo             = input fi-gm-codigo
            tt-movto-ggf.tipo-trans            = if return-value = "yes" 
                                                    then 1
                                                    else 2
            tt-movto-ggf.cd-tecnico            = input fi-cd-tecnico                                        
            tt-movto-ggf.cd-tarefa             = input fi-cd-tarefa
            tt-movto-ggf.rw-mov-orig           = if avail movto-ggf then
                                                    rowid (movto-ggf)
                                                 else ?
            tt-movto-ggf.op-seq                = if avail oper-ord then
                                                    oper-ord.sequencia
                                                 else 0
            tt-movto-ggf.dt-retorno            = if return-value = "yes"
                                                    then ?
                                                    else da-dt-retorno                                    
            tt-movto-ggf.num-id-movto-ggf = ?.
           
    

     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-dt-trans").
     assign tt-movto-ggf.dt-trans = date(return-value).
 
     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-horas-report").      
     assign tt-movto-ggf.horas-report = decimal (return-value).     
 
     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-referencia").
     assign tt-movto-ggf.referencia = return-value.

      RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-matr-func").
      assign tt-movto-ggf.matr-func = int(return-value).

     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-cd-turno").
     assign tt-movto-ggf.cd-turno = return-value.
 
     assign tt-movto-ggf.lg-recalc-horas = yes.
 
     run cpp/cpapi005.p (input-output table tt-movto-ggf,
                         input-output table tt-erro,
                         input        yes).
 
     find first tt-erro no-lock no-error.
     if avail tt-erro then do:
        run cdp/cd0666.w (input table tt-erro).
        undo, return "adm-error".
     end.
     else do:
        /** 
        *** Criacao de Ponto Estrategico (UPC) 
        *** Carlos Rafael Nobrega - DATAMASTER 
        *** Colocado o FIND FIRST, pois o Progress
        *** se perde.
        ***/
        
        find first tt-movto-ggf no-error.
        if avail tt-movto-ggf then do:
           run pi-cria-upc.
        end.   
         
     end.

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        run pi-utilizacao.
    &endif
end.
 
disable all with frame {&frame-name}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-utilizacao V-table-Win 
PROCEDURE pi-utilizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
    if valid-handle(h-bomn161) then do:

        run emptyRowErrors in h-bomn161.
        run getTTUtiliza in h-bomn161(output table tt-utiliza).

        if can-find(first tt-utiliza) then do:

            if l-interf-util then do: /* Caso interfira, permitira o usu†rio alterar as informaá‰es */

                do while l-ok:

                    run cpp/cp0311mi.w (input-output table tt-utiliza,
                                        input 1,
                                        input h-bomn161,
                                        output l-ok).

                    if not l-ok then do: /* pressionado bot∆o cancela */

                        run utp/ut-msgs.p (input "show":u,
                                           input 30133,
                                           input "").

                        if return-value = "YES":U then
                            assign l-ok = yes.
                    end.
                    else
                        assign l-ok = NO.
                end.
            end.
            else do: /* Caso n∆o interfira, ser† gerada a utilizaá∆o automaticamente */

                for each tt-utiliza no-lock:
                    if p-cd-tecnico-ant <> tt-utiliza.cd-tecnico then do:

                        run verificaTecnicoMI in h-bomn161 (input tt-utiliza.cd-tecnico).

                        assign p-cd-tecnico-ant = tt-utiliza.cd-tecnico.

                    end.
                end.

                run getRowErrors in h-bomn161 (output table RowErrors).

                find first rowErrors no-error.
                if avail rowErrors then
                    run utp/ut-msgs.p (input "show":u,
                                       input 30132,
                                       input "").
                else
                    run PropagaUtilizacaoEquipto in h-bomn161 (input table tt-utiliza, 
                                                               input 1).
            end.
        end.

    end.

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
  {src/adm/template/snd-list.i "movto-ggf"}

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


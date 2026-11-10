&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V02AD107 2.00.00.113 } /*** "010013" 06/02/2026 11:11:17 ***/
{cep/ce0101.i2}  /* Verifica Paramento Estoque Agrupa Estabelecimento Por Empresa */


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02ad107 MUT}
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

{include/i-vrtab.i estabelec}

def new global shared var v-row-parent as rowid no-undo.                                

def var c-verifica-cgc      as char format "x(20)"    no-undo.
def var c-formato-cgc       as char                   no-undo.
def var c-cnpj              as char                   no-undo.
def var i-dig-ver           as integer                no-undo.
def var v_handle_folder     as handle                 no-undo.
DEF VAR h_v03ad107          AS HANDLE                 NO-UNDO.
def var l-pais              as logical                no-undo.
def var l-mostra            as logical                no-undo.
def buffer b-estabelec for estabelec.

def var c-cep-aux  as char format "x(12)" no-undo.
def var c-cep-aux2 as char format "x(12)" no-undo.

def var c-cep-unformat      as char.

{cdp/cd9900.i1}
{cdp/cdcfgdis.i}

DEF VAR c-endereco-aux LIKE emitente.endereco NO-UNDO.
DEF VAR c-rua               AS CHAR                NO-UNDO.
DEF VAR c-nro               AS CHAR                NO-UNDO.
DEF VAR c-comp              AS CHAR                NO-UNDO.
DEF VAR c-help              AS CHAR                NO-UNDO.
DEF VAR h-cdapi704          AS HANDLE              NO-UNDO.
DEF VAR h-boad00574         AS HANDLE              NO-UNDO.
DEF VAR h-bodi520           AS HANDLE              NO-UNDO.
DEF VAR hShowMsg            AS HANDLE              NO-UNDO.
DEF VAR l-envio-tss         AS LOG                 NO-UNDO.
DEF VAR c-ct-dif-total-nota AS CHAR                NO-UNDO. 
DEF VAR c-sc-dif-total-nota AS CHAR                NO-UNDO. 

DEFINE TEMP-TABLE tt-estab-internac NO-UNDO LIKE estab-internac
    FIELD r-rowid AS ROWID.

{method/dbotterr.i}

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.cidade estabelec.pais estabelec.cgc ~
estabelec.serie estabelec.ins-estadual estabelec.ep-codigo ~
estabelec.ins-municipal estabelec.cod-suframa estabelec.estado ~
estabelec.serie-manual estabelec.grupo-aloca 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS RECT-1 dt-fim-ativ 
&Scoped-Define DISPLAYED-FIELDS estabelec.cidade estabelec.pais ~
estabelec.cgc estabelec.serie estabelec.ins-estadual estabelec.ep-codigo ~
estabelec.ins-municipal estabelec.cod-suframa estabelec.estado ~
estabelec.serie-manual estabelec.grupo-aloca 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-nom-fantasia c-endereco c-bairro ~
c-serie-nfse c-cod-fiscal-estab c-cod-postal c-desc c-zip-cod de-cod-nire ~
c-cod-munic-sat c-cep dt-fim-ativ c-cod-rep-fis c-cod-cnae 

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
DEFINE VARIABLE c-bairro AS CHARACTER FORMAT "X(60)":U 
     LABEL "Bairro" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-cep AS CHARACTER FORMAT "99999999":U 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cnae AS CHARACTER FORMAT "9999-9/99":U 
     LABEL "Cod CNAE":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-fiscal-estab AS INTEGER FORMAT ">>>>":U INITIAL 0 
     LABEL "C¢d. Fiscal Estabelec." 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-munic-sat AS CHARACTER FORMAT "X(04)":U 
     LABEL "Municip. SAT" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-postal AS CHARACTER FORMAT "X(05)":U 
     LABEL "C¢d. Postal" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rep-fis AS CHARACTER FORMAT "X(20)":U 
     LABEL "Cod. Repart. Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-endereco AS CHARACTER FORMAT "X(60)":U 
     LABEL "Endereáo" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-nom-fantasia AS CHARACTER FORMAT "X(60)":U 
     LABEL "Nome Fantasia" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-nfse AS CHARACTER FORMAT "X(5)":U 
     LABEL "SÇrie NFS-e" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-zip-cod AS CHARACTER FORMAT "999999" 
     LABEL "UBIGEO" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-cod-nire AS DECIMAL FORMAT "99999999999":U INITIAL 0 
     LABEL "NIRE" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE dt-fim-ativ AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Fim Atividades" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.14 BY 12.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-nom-fantasia AT ROW 1.25 COL 21 COLON-ALIGNED HELP
          "Nome Fantasia do Estabelecimento"
     c-endereco AT ROW 2.25 COL 21 COLON-ALIGNED HELP
          "Endereáo do Estabelecimento"
     c-bairro AT ROW 3.25 COL 21 COLON-ALIGNED HELP
          "Bairro do Estabelecimento"
     estabelec.cidade AT ROW 4.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     estabelec.pais AT ROW 5.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     estabelec.cgc AT ROW 6.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     estabelec.serie AT ROW 7.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-serie-nfse AT ROW 8.25 COL 21 COLON-ALIGNED HELP
          "SÇrie padr∆o de emiss∆o de notas de serviáo"
     estabelec.ins-estadual AT ROW 9.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     estabelec.ep-codigo AT ROW 10.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-cod-fiscal-estab AT ROW 11.25 COL 21 COLON-ALIGNED
     estabelec.ins-municipal AT ROW 11.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     c-cod-postal AT ROW 11.25 COL 21 COLON-ALIGNED
     estabelec.cod-suframa AT ROW 12.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     c-desc AT ROW 10.25 COL 26 COLON-ALIGNED NO-LABEL
     c-zip-cod AT ROW 4.25 COL 61 COLON-ALIGNED
     de-cod-nire AT ROW 4.25 COL 61 COLON-ALIGNED
     c-cod-munic-sat AT ROW 4.25 COL 61 COLON-ALIGNED
     c-cep AT ROW 5.25 COL 61 COLON-ALIGNED
     estabelec.estado AT ROW 6.21 COL 61 COLON-ALIGNED FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     estabelec.serie-manual AT ROW 7.21 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     estabelec.grupo-aloca AT ROW 8.21 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     dt-fim-ativ AT ROW 9.21 COL 61 COLON-ALIGNED
     c-cod-rep-fis AT ROW 11.25 COL 61 COLON-ALIGNED
     c-cod-cnae AT ROW 12.25 COL 61 COLON-ALIGNED HELP
          "Informar a Classificaá∆o Nacional de Atividade Econìmica":U
     RECT-1 AT ROW 1.04 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 12.42
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-bairro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cep IN FRAME f-main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN c-cod-cnae IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-fiscal-estab IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-fiscal-estab:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-munic-sat IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-munic-sat:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-postal IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-postal:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-rep-fis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-endereco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nom-fantasia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-serie-nfse IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-zip-cod IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-zip-cod:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       estabelec.cod-suframa:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-cod-nire IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       dt-fim-ativ:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN estabelec.estado IN FRAME f-main
   EXP-FORMAT                                                           */
ASSIGN 
       estabelec.ins-municipal:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cep V-table-Win
ON LEAVE OF c-cep IN FRAME f-main /* c-cep */
DO:
  if length(c-cep:format in frame {&FRAME-NAME}) <> 
     length(c-cep:screen-value in frame {&FRAME-NAME}) then do:
       run utp/ut-msgs.p(input "show",
                              input 4334,
                              input trim(return-value)).
       return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cnae
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cnae V-table-Win
ON LEAVE OF c-cod-cnae IN FRAME f-main /* Cod CNAE */
DO:
  {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie-nfse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-nfse V-table-Win
ON F5 OF c-serie-nfse IN FRAME f-main /* SÇrie NFS-e */
DO:
   assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                       &campo=c-serie-nfse
                       &campozoom=serie
                       &frame=f-main}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie-nfse V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-serie-nfse IN FRAME f-main /* SÇrie NFS-e */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-zip-cod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-zip-cod V-table-Win
ON LEAVE OF c-zip-cod IN FRAME f-main /* UBIGEO */
DO:
 IF LENGTH(c-zip-cod:FORMAT IN FRAME {&FRAME-NAME}) <> 
    LENGTH(c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO: 
    
     ASSIGN c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME} =  FILL("0", LENGTH(c-zip-cod:FORMAT IN FRAME {&FRAME-NAME}) - LENGTH(c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
     RETURN NO-APPLY.
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cgc V-table-Win
ON ENTRY OF estabelec.cgc IN FRAME f-main /* CGC */
DO:
  /*  assign mgadm.estabelec.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cgc V-table-Win
ON LEAVE OF estabelec.cgc IN FRAME f-main /* CGC */
DO:
   {cdp/cd9998.i}
   
   IF i-pais-impto-usuario = 1 THEN DO:
      /* Foráar letras para ma°sculo */
	  ASSIGN estabelec.cgc:SCREEN-VALUE = CAPS(estabelec.cgc:SCREEN-VALUE).
   END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ep-codigo V-table-Win
ON F5 OF estabelec.ep-codigo IN FRAME f-main /* Empresa */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un004.w
                     &campo=estabelec.ep-codigo
                     &campozoom=ep-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ep-codigo V-table-Win
ON LEAVE OF estabelec.ep-codigo IN FRAME f-main /* Empresa */
DO:
  {include/leave.i &tabela=empresa
                   &atributo-ref=nome
                   &variavel-ref=c-desc
                   &where="empresa.ep-codigo = input frame {&frame-name}
                                                   estabelec.ep-codigo"}

  {cep/ce0101.i2}
  IF l-agr-estab-emp AND estabelec.ep-codigo <> estabelec.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:
     
        run utp/ut-msgs.p (input "show", input 53954, input "").
      
  END.
  IF  i-pais-impto-usuario = 21 
  AND estabelec.ep-codigo:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      FOR FIRST empresa NO-LOCK
          WHERE empresa.ep-codigo = estabelec.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
          ASSIGN estabelec.cgc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = empresa.cgc.
      END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ep-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ep-codigo IN FRAME f-main /* Empresa */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.estado V-table-Win
ON F5 OF estabelec.estado IN FRAME f-main /* UF */
DO:
  
    assign l-implanta = yes.  
    {include/zoom.i &prog-zoom="unzoom/z01un007.w"
                  &tabela=estabelec
                  &atributo=estado}
                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.estado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.estado IN FRAME f-main /* UF */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.grupo-aloca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.grupo-aloca V-table-Win
ON F5 OF estabelec.grupo-aloca IN FRAME f-main /* Grupo Alocaá∆o */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=estabelec.grupo-aloca
                     &campozoom=cod-estabel}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.grupo-aloca V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.grupo-aloca IN FRAME f-main /* Grupo Alocaá∆o */
DO:
  apply "F5" to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ins-estadual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ins-estadual V-table-Win
ON LEAVE OF estabelec.ins-estadual IN FRAME f-main /* Inscriá∆o Estadual */
DO:
  {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.pais V-table-Win
ON F5 OF estabelec.pais IN FRAME f-main /* Pa°s */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="unzoom/z01un006.w"
                       &campo=estabelec.pais
                       &campozoom=nome-pais}                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.pais V-table-Win
ON LEAVE OF estabelec.pais IN FRAME f-main /* Pa°s */
DO:
  if input frame {&FRAME-NAME} estabelec.pais = "Brasil" then 
    assign l-pais = yes.
  else 
    assign l-pais = no.
  
  assign l-mostra = yes.  
  
  run pi-executa-disable in v_handle_folder (input l-pais, input l-mostra).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.pais IN FRAME f-main /* Pa°s */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.serie V-table-Win
ON F5 OF estabelec.serie IN FRAME f-main /* SÇrie */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in407.w"
                   &tabela=estabelec
                   &atributo=serie}                    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.serie V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.serie IN FRAME f-main /* SÇrie */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.serie-manual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.serie-manual V-table-Win
ON F5 OF estabelec.serie-manual IN FRAME f-main /* SÇrie Manual */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                       &campo=estabelec.serie-manual
                       &campozoom=serie}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.serie-manual V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.serie-manual IN FRAME f-main /* SÇrie Manual */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if estabelec.pais:load-mouse-pointer         ("image/lupa.cur") then.
  if estabelec.serie:load-mouse-pointer        ("image/lupa.cur") then.
  if estabelec.serie-manual:load-mouse-pointer ("image/lupa.cur") then.
  if estabelec.ep-codigo:load-mouse-pointer    ("image/lupa.cur") then.
  if estabelec.estado:load-mouse-pointer       ("image/lupa.cur") then.
  if estabelec.grupo-aloca:load-mouse-pointer  ("image/lupa.cur") then.
  if c-serie-nfse:load-mouse-pointer           ("image/lupa.cur") then.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).
    find first param-global no-lock no-error.
    find empresa no-lock where 
      empresa.ep-codigo = param-global.empresa-prin no-error.

/*    assign estabelec.ep-codigo:screen-value in frame {&frame-name} = string(i-ep-codigo-usuario).*/

    assign estabelec.ep-codigo:screen-value in frame {&frame-name} = string(empresa.ep-codigo)
           c-desc:screen-value = empresa.nome.
                    
/*    if  avail empresa then
 *         assign c-desc:screen-value = empresa.nome.
 *     else 
 *         assign c-desc:screen-value = "".*/
  
    assign estabelec.pais:screen-value in frame {&frame-name} = empresa.pais.    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var c-aux                  as char no-undo.
  DEF VAR tp-integ               AS CHAR NO-UNDO.
  DEF VAR c-cod-municip-sat      AS CHAR NO-UNDO.
  DEF VAR c-cod-postal-aux       AS CHAR NO-UNDO.
  DEF VAR c-cod-fiscal-estab-aux AS INT  NO-UNDO.
  DEF VAR dt-fim-ativ-aux        AS DATE NO-UNDO.

  {include/i-valid.i}

  assign c-cep-unformat = replace(input frame {&frame-name} c-cep,".","")
         c-cep-unformat = replace(c-cep-unformat,",","") 
         c-cep-unformat = replace(c-cep-unformat,"-","")
         c-cep-unformat = replace(c-cep-unformat,";","").
         
  assign c-aux = input frame {&frame-name} c-cod-rep-fis.

  ASSIGN INPUT FRAME {&FRAME-NAME} c-endereco
                                   c-bairro
                                   c-nom-fantasia
                                   c-serie-nfse.
  /* Integraá∆o NFe X TSS */

  IF i-pais-impto-usuario = 4 THEN
      ASSIGN c-cod-municip-sat = INPUT FRAME {&FRAME-NAME} c-cod-munic-sat
             c-cod-postal-aux = INPUT FRAME {&FRAME-NAME} c-cod-postal.
             
  IF i-pais-impto-usuario = 33 /*Peru*/ THEN    
      ASSIGN c-zip-cod = INPUT FRAME {&FRAME-NAME} c-zip-cod.                

  IF  i-pais-impto-usuario = 6  /* Uruguai  */
  OR  i-pais-impto-usuario = 9  /* Paraguai */
  OR  i-pais-impto-usuario = 33 /* Peru     */ THEN DO:

      ASSIGN c-cod-fiscal-estab-aux = INPUT FRAME {&FRAME-NAME} c-cod-fiscal-estab.

      IF VALID-HANDLE(h_v03ad107) THEN 
        RUN pi-get-estab-internac-ury IN h_v03ad107 (OUTPUT c-ct-dif-total-nota,
                                                     OUTPUT c-sc-dif-total-nota).
  END.

  IF i-pais-impto-usuario = 21 /* Equador */ THEN
      ASSIGN dt-fim-ativ-aux = INPUT FRAME {&FRAME-NAME} dt-fim-ativ.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                     INPUT "",
                     OUTPUT tp-integ).

  IF  LOOKUP ("TSS":U, tp-integ) > 0 OR 
      LOOKUP ("TC":U, tp-integ)  > 0 THEN DO:
 
      ASSIGN l-envio-tss = NO.

      IF CAN-FIND(FIRST param-nf-estab WHERE
                        param-nf-estab.cod-estabel = estabelec.cod-estabel) THEN DO:

         IF estabelec.endereco      <> INPUT FRAME {&frame-name} c-endereco              OR
            estabelec.bairro        <> INPUT FRAME {&frame-name} c-bairro                OR
            estabelec.cidade        <> INPUT FRAME {&frame-name} estabelec.cidade        OR
            estabelec.pais          <> INPUT FRAME {&frame-name} estabelec.pais          OR
            estabelec.cgc           <> INPUT FRAME {&frame-name} estabelec.cgc           OR
            estabelec.ins-estadual  <> INPUT FRAME {&frame-name} estabelec.ins-estadual  OR
            estabelec.ins-municipal <> INPUT FRAME {&frame-name} estabelec.ins-municipal OR
            estabelec.cod-suframa   <> INPUT FRAME {&frame-name} estabelec.cod-suframa   THEN
            ASSIGN l-envio-tss = YES.
      END.
  END.

  FIND FIRST estab-compl EXCLUSIVE-LOCK
       WHERE estab-compl.cod-estabel = estabelec.cod-estabel NO-ERROR.

  IF  NOT AVAIL estab-compl THEN DO:
      CREATE estab-compl.
      ASSIGN estab-compl.cod-estabel = estabelec.cod-estabel.
  END.
  ASSIGN estab-compl.nom-fantasia = trim(c-nom-fantasia).  

  ASSIGN estabelec.endereco    = c-endereco
         estabelec.bairro      = c-bairro.

  ASSIGN OVERLAY(estabelec.char-2,233,5) = c-serie-nfse.
  
  if return-value = "adm-error":U then
    return "adm-error":U.

  IF i-pais-impto-usuario = 4 THEN
      ASSIGN OVERLAY(estabelec.char-2,224,4) = c-cod-municip-sat
             OVERLAY(estabelec.char-2,228,5) = c-cod-postal-aux.
             
  IF i-pais-impto-usuario = 33 THEN
      ASSIGN estabelec.zip-cod = c-zip-cod.          

  IF (i-pais-impto-usuario = 6 
  OR  i-pais-impto-usuario = 9 /* Paraguai */
  OR  i-pais-impto-usuario = 21 /* Equador */
  OR  i-pais-impto-usuario = 33 /* Peru */) 
  AND VALID-HANDLE(h-boad00574)THEN DO:

      EMPTY TEMP-TABLE tt-estab-internac.

      RUN goToKey IN h-boad00574(INPUT estabelec.cod-estabel).

      IF RETURN-VALUE = "OK":U THEN DO:
          RUN getRecord      IN h-boad00574 (OUTPUT TABLE tt-estab-internac).
          FIND FIRST tt-estab-internac EXCLUSIVE-LOCK NO-ERROR.
          ASSIGN tt-estab-internac.cod-estab-fisc = string(c-cod-fiscal-estab-aux)
                 OVERLAY(tt-estab-internac.cod-livre-1,1,20)  = c-ct-dif-total-nota
                 OVERLAY(tt-estab-internac.cod-livre-1,21,20) = c-sc-dif-total-nota
                 tt-estab-internac.dat-livre-1                = dt-fim-ativ-aux.
          
             
          RUN emptyRowErrors IN h-boad00574.
          RUN emptyRowObject IN h-boad00574.
          RUN setRecord      IN h-boad00574(INPUT TABLE tt-estab-internac).
          RUN updateRecord   IN h-boad00574.
      END.
      ELSE DO:
          CREATE tt-estab-internac.                                             
          ASSIGN tt-estab-internac.cod-estabel    = estabelec.cod-estabel   
                 tt-estab-internac.cod-estab-fisc = string(c-cod-fiscal-estab-aux)
                 OVERLAY(tt-estab-internac.cod-livre-1,1,20)  = c-ct-dif-total-nota
                 OVERLAY(tt-estab-internac.cod-livre-1,21,20) = c-sc-dif-total-nota
                 tt-estab-internac.dat-livre-1                = dt-fim-ativ-aux. 
                 
          RUN emptyRowErrors IN h-boad00574.
          RUN emptyRowObject IN h-boad00574.
          RUN setRecord      IN h-boad00574(INPUT TABLE tt-estab-internac).
          RUN createRecord   IN h-boad00574.               
      END.

      IF RETURN-VALUE = "NOK" THEN DO: 
          RUN getRowErrors in h-boad00574(OUTPUT TABLE RowErrors).

          IF CAN-FIND(FIRST RowErrors
           WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            
            RETURN "NOK":U.    
          END.
      END.  
  END.

  IF i-pais-impto-usuario = 21 THEN DO:
      FOR FIRST empresa NO-LOCK
          WHERE empresa.ep-codigo = estabelec.ep-codigo:
          ASSIGN estabelec.cgc = empresa.cgc.
      end.
  END.

  IF l-envio-tss THEN DO:
     
     /* Envia XML (AdmEmpresa) para o TSS */
     IF NOT VALID-HANDLE(h-bodi520) THEN DO:
         RUN dibo/bodi520.p PERSISTENT SET h-bodi520.
         RUN openQueryStatic IN h-bodi520 (INPUT "Main":U).
     END.

     EMPTY TEMP-TABLE RowErrors.
     RUN emptyRowErrors IN h-bodi520.
     RUN runAdaptersTSS IN h-bodi520 (INPUT estabelec.cod-estabel,
                                      INPUT YES,     
                                      INPUT NO,
                                      INPUT NO,
                                      INPUT NO,     
                                      INPUT NO,    
                                      INPUT NO,     
                                      INPUT NO,     
                                      INPUT NO, 
                                      INPUT NO,
                                      INPUT NO,
                                      OUTPUT TABLE RowErrors).
      FOR FIRST RowErrors
          WHERE RowErrors.ErrorType <> "INTERNAL":U NO-LOCK:
  
          RUN utp/ut-msgs.p(INPUT "show":U,
                            INPUT 17006,
                            INPUT RowErrors.ErrorDescription + '~~' + RowErrors.ErrorHelp).
          UNDO, RETURN 'ADM-ERROR':U. 
     END.
  END.

 
  assign estabelec.cep = integer(c-cep-unformat)
         substr(estabelec.char-2,62,20) = STRING(c-aux,"x(20)").

  /* COD CNAE */
  FIND FIRST reg-inf-compl
       WHERE reg-inf-compl.cod-tab-inform   = "estabelec":U
         AND reg-inf-compl.cod-campo-inform = "cod-cnae":U NO-LOCK NO-ERROR.

  IF  NOT AVAIL reg-inf-compl THEN DO:
      CREATE reg-inf-compl.
      ASSIGN reg-inf-compl.cdn-identif        = 2
             reg-inf-compl.cod-tab-inform     = "estabelec":U
             reg-inf-compl.cod-campo-inform   = "cod-cnae":U 
             reg-inf-compl.des-campo-inform   = "C¢digo CNAE":U
             reg-inf-compl.idi-tipo           = 2 /* character */
             reg-inf-compl.num-decimal        = 0
             reg-inf-compl.cod-format-campo   = "9999-9/99":U.
  END.
  
  FIND FIRST inf-compl
       WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
         AND inf-compl.cod-indice  = estabelec.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
        
  IF  AVAIL inf-compl THEN
     DELETE inf-compl.
    
         CREATE inf-compl.
     ASSIGN inf-compl.cdn-identif = reg-inf-compl.cdn-identif
            inf-compl.cod-indice  = estabelec.cod-estabel.
                    inf-compl.des-campo   = replace(replace(REPLACE(c-cod-cnae:screen-value in frame {&frame-name}," ",""),"/",""),"-","").
  
  /* FIM - COD CNAE */
  
  /*  SEF 2 - COD NIRE */
  ASSIGN estabelec.val-livre-1 = INPUT FRAME {&FRAME-NAME} de-cod-nire.
         

  RUN get-attribute ('adm-new-record').
  if  return-value = "yes":U then do:
      assign estabelec.ep-codigo = i-ep-codigo-usuario.  
  end.

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

  IF VALID-HANDLE(h-bodi520) THEN DO:
     DELETE PROCEDURE h-bodi520.
     ASSIGN h-bodi520 = ?.
  END.

  IF VALID-HANDLE(h-boad00574) THEN DO:
     RUN destroy in h-boad00574.
     ASSIGN h-boad00574 = ?.
  END.

  {method/showmessage.i3}


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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  disable c-cep c-cod-rep-fis c-cod-cnae c-endereco c-bairro de-cod-nire c-nom-fantasia c-serie-nfse with frame {&frame-name}.

  IF i-pais-impto-usuario = 4 THEN
      ASSIGN c-cod-munic-sat:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             c-cod-postal:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
  IF i-pais-impto-usuario = 33 THEN
      ASSIGN c-zip-cod:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
       
  IF i-pais-impto-usuario = 6 OR i-pais-impto-usuario = 9 OR i-pais-impto-usuario = 33 THEN
      ASSIGN c-cod-fiscal-estab:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF i-pais-impto-usuario = 21 THEN
      ASSIGN dt-fim-ativ:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  if avail estabelec then
     assign c-cep = string(estabelec.cep). 

  if avail param-global then
    assign c-cep:format in frame {&frame-name} = param-global.formato-cep.  

  if avail estabelec then
     assign c-cep-aux = param-global.formato-cep
            c-cep-aux = replace(c-cep-aux,".","")
            c-cep-aux = replace(c-cep-aux,"-","")
            c-cep-aux = replace(c-cep-aux,";","")
            c-cod-rep-fis = substr(estabelec.char-2,62,20).
  
  /* COD CNAE */
  IF  AVAIL estabelec THEN DO:
      FOR FIRST reg-inf-compl NO-LOCK
          WHERE reg-inf-compl.cod-tab-inform   = "estabelec":U
            AND reg-inf-compl.cod-campo-inform = "cod-cnae":U,
          FIRST inf-compl NO-LOCK
          WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
            AND inf-compl.cod-indice  = estabelec.cod-estabel:
      
      END.
      IF  AVAIL inf-compl AND
          inf-compl.des-campo <> "" THEN
          ASSIGN c-cod-cnae = inf-compl.des-campo.
      ELSE 
          ASSIGN c-cod-cnae = "0000000".
  END.
  /* FIM - COD CNAE */
  
  /* SEF 2 - COD NIRE*/
  


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
          
assign c-cep:format in frame {&frame-name} = param-global.formato-cep.

  
if avail estabelec and
   length(string(estabelec.cep)) < length(c-cep-aux) then
   assign c-cep:screen-value in frame {&frame-name} = fill("0",length(c-cep-aux) - length(string(estabelec.cep))) + string(estabelec.cep).
          
  apply 'leave':U to estabelec.ep-codigo in frame {&FRAME-NAME}.
        
  if  avail estabelec then do:
      if  estabelec.pais = "Brasil" then 
          assign l-pais = yes.
      else 
          assign l-pais = no.
  end.
  
  assign l-mostra = no.
        
  run pi-executa-disable in v_handle_folder (input l-pais, input l-mostra).
  IF i-pais-impto-usuario = 4 THEN DO:
      ASSIGN c-cod-munic-sat:HIDDEN IN FRAME {&FRAME-NAME} = NO
             c-cod-postal:HIDDEN IN FRAME {&FRAME-NAME} = NO.

      IF AVAIL estabelec THEN
          ASSIGN c-cod-munic-sat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(SUBSTRING(estabelec.char-2,224,4))
                 c-cod-postal:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(SUBSTRING(estabelec.char-2,228,5)).
  END.
  
  IF i-pais-impto-usuario = 33 THEN DO:
      ASSIGN c-zip-cod:HIDDEN IN FRAME {&FRAME-NAME} = NO.

      IF AVAIL estabelec THEN
          ASSIGN c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(estabelec.zip-cod).
  END.

  IF i-pais-impto-usuario = 6 OR 
     i-pais-impto-usuario = 9 OR 
     i-pais-impto-usuario = 21 or
     i-pais-impto-usuario = 33 THEN DO:
      
      EMPTY TEMP-TABLE tt-estab-internac.

      IF AVAIL estabelec THEN DO:          
          IF VALID-HANDLE(h-boad00574) THEN DO:
              RUN emptyRowErrors IN h-boad00574.               
              RUN emptyRowObject IN h-boad00574.
              RUN goToKey        IN h-boad00574 (INPUT estabelec.cod-estabel).
              
              IF RETURN-VALUE = "OK":U THEN DO:
                  RUN getRecord IN h-boad00574 (OUTPUT TABLE tt-estab-internac).              
              END.
          END.
      END.
   
      IF i-pais-impto-usuario = 6 OR 
         i-pais-impto-usuario = 9 or
         i-pais-impto-usuario = 33 THEN DO:

          ASSIGN c-cod-fiscal-estab:HIDDEN IN FRAME {&FRAME-NAME} = NO.

          IF AVAIL estabelec THEN DO:
              FIND FIRST tt-estab-internac NO-LOCK NO-ERROR.
              IF AVAIL tt-estab-internac THEN 
                  ASSIGN c-cod-fiscal-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt-estab-internac.cod-estab-fisc.
    
              IF VALID-HANDLE(h_v03ad107) THEN
                 RUN pi-disp-estab-internac IN h_v03ad107 (INPUT TABLE tt-estab-internac).
          END.
      END.

  IF i-pais-impto-usuario = 21 THEN DO:
     ASSIGN dt-fim-ativ:HIDDEN IN FRAME {&FRAME-NAME} = NO.

      FIND FIRST tt-estab-internac NO-LOCK NO-ERROR.
      IF AVAIL tt-estab-internac THEN 
          ASSIGN dt-fim-ativ:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tt-estab-internac.dat-livre-1).
      ELSE
          ASSIGN dt-fim-ativ:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  END.
      

     
  END.

  IF  AVAIL estabelec THEN
      ASSIGN de-cod-nire :screen-value in frame f-main        = string(estabelec.val-livre-1)
             c-endereco  :screen-value in frame {&frame-name} = estabelec.endereco
             c-bairro    :screen-value in frame {&frame-name} = estabelec.bairro
             c-serie-nfse:screen-value in frame {&frame-name} = trim(substring(estabelec.char-2,233,5)).

  FOR FIRST estab-compl NO-LOCK
      WHERE estab-compl.cod-estabel = estabelec.cod-estabel:

      ASSIGN c-nom-fantasia:screen-value in frame {&frame-name} = estab-compl.nom-fantasia.
  END.

  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN c-cod-rep-fis:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
             c-cod-cnae:HIDDEN IN FRAME {&FRAME-NAME} = TRUE 
             de-cod-nire:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
             c-serie-nfse:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  run get-attribute ('adm-new-record').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  enable c-cep c-cod-rep-fis c-cod-cnae de-cod-nire c-endereco c-bairro c-nom-fantasia c-serie-nfse with frame {&frame-name}.

  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN c-cod-rep-fis:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
             c-cod-cnae:HIDDEN IN FRAME {&FRAME-NAME} = TRUE 
             de-cod-nire:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
             c-serie-nfse:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
             .
  
  RUN get-attribute ('adm-new-record').
  if  return-value = "yes":U then do:
    assign l-pais = yes
           l-mostra = yes.
  end.  
  
  run pi-executa-disable in v_handle_folder (input l-pais, input l-mostra).

  &if  defined(ADM-MODIFY-FIELDS) &then do:
      enable {&ADM-MODIFY-FIELDS}  with frame {&frame-name}.
  end.    
  &endif
 
  IF i-pais-impto-usuario = 21 THEN
      ASSIGN estabelec.cgc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             dt-fim-ativ:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.

  IF i-pais-impto-usuario = 4 THEN
      ASSIGN c-cod-munic-sat:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             c-cod-postal:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
             
  IF i-pais-impto-usuario = 33 THEN
      ASSIGN c-zip-cod:SENSITIVE IN FRAME {&FRAME-NAME} = YES.           
     
  IF i-pais-impto-usuario = 6 OR i-pais-impto-usuario = 9 OR i-pais-impto-usuario = 33 THEN
      ASSIGN c-cod-fiscal-estab:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   
  FIND FIRST param-global NO-LOCK NO-ERROR.
  
  IF AVAIL param-global THEN DO:             

     ASSIGN estabelec.cgc:FORMAT IN FRAME {&frame-name} = param-global.formato-id-federal.
     
     IF i-pais-impto-usuario <> 1 THEN DO: /* Brasil */
        ASSIGN estabelec.cgc:LABEL IN FRAME {&FRAME-NAME} = param-global.label-cgc.  
     END.
     
  END.

  IF (i-pais-impto-usuario = 6 /* Uruguai */  OR 
      i-pais-impto-usuario = 9 /* Paraguai */ OR 
      i-pais-impto-usuario = 33 /* Peru */ OR 
      i-pais-impto-usuario = 21 /* Equador */) AND NOT VALID-HANDLE(h-boad00574) THEN DO:                
      RUN adbo/boad00574.p PERSISTENT SET h-boad00574.     
      RUN openQueryStatic IN h-boad00574 (INPUT "Main":U). 
      
      IF i-pais-impto-usuario = 9 THEN
         ASSIGN c-cod-fiscal-estab:FORMAT IN FRAME {&frame-name} = "999".
          
      IF i-pais-impto-usuario = 33 THEN
         ASSIGN c-cod-fiscal-estab:FORMAT IN FRAME {&frame-name} = "9999".          
  END.   

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i "CEP" * R}
  ASSIGN c-cep:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  
  IF i-pais-impto-usuario = 1 THEN DO: /* Brasil */
     {utp/ut-liter.i "CNPJ" * R}
     ASSIGN estabelec.cgc:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if  avail estabelec then do:
      assign gr-estabelec = rowid(estabelec).
  end.

  DEFINE VARIABLE tp-integ AS CHARACTER   NO-UNDO.

  RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                     INPUT "":U,
                     OUTPUT tp-integ).

  IF  LOOKUP("TSS":U, tp-integ) > 0
  OR  LOOKUP("TC":U , tp-integ) > 0 THEN DO: /*Bot∆o Configuraá‰es TSS - cd0403b.w*/
      if  valid-handle(v_handle_folder) then run pi-habilita-tss IN v_handle_folder (input YES).
  END.
  ELSE DO:
      if  valid-handle(v_handle_folder) then run pi-habilita-tss IN v_handle_folder (input NO).
  END.


  RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                     INPUT "NFS-e":U,
                     OUTPUT tp-integ).
  
  IF LOOKUP("TC2":U, tp-integ) > 0
  OR LOOKUP("TPF":U, tp-integ) > 0 THEN DO: /*Bot∆o Configuraá‰es NFS-e - cd0403c.w*/
      if  valid-handle(v_handle_folder) then run pi-habilita-nfse IN v_handle_folder (input YES).
  END.
  ELSE DO:
      if  valid-handle(v_handle_folder) then run pi-habilita-nfse IN v_handle_folder (input NO).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  if  i-pais-impto-usuario = 1 then do:
      assign estabelec.cod-suframa:visible in frame {&FRAME-NAME} = yes.
  end.
  else do:
      assign estabelec.cod-suframa:visible in frame {&FRAME-NAME} = no.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-empresa V-table-Win 
PROCEDURE pi-busca-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAM p-empresa AS CHAR NO-UNDO.

  ASSIGN p-empresa = estabelec.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    def input parameter h_folder as handle no-undo. 
    DEF INPUT PARAMETER p_h_v03ad107 AS HANDLE NO-UNDO.
              
    assign v_handle_folder = h_folder
           h_v03ad107      = p_h_v03ad107.
        
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
      
    IF i-pais-impto-usuario <> 1 THEN DO: /* Brasil */
       APPLY 'leave' TO mgadm.estabelec.cgc IN FRAME {&FRAME-NAME}.
    END.   
       
    {include/i-vldfrm.i}
    
    if  input frame {&frame-name} estabelec.pais:sensitive then do:
        find first pais
            where pais.nome-pais   = input frame {&frame-name} estabelec.pais no-lock no-error.
        if  not avail pais then do:
            {include/i-vldprg.i}  
            {utp/ut-liter.i Pa°s * C}
            run utp/ut-msgs.p(input "show",
                              input 964,
                              input trim(return-value)).
            apply 'entry' to estabelec.pais in frame {&frame-name}.
            return 'ADM-ERROR':U. 
        end.
    end.

            
    if  input frame {&frame-name} estabelec.estado:sensitive then do:
        find first unid-feder
             where unid-feder.pais   = input frame {&frame-name} estabelec.pais
             and   unid-feder.estado = input frame {&frame-name} estabelec.estado no-lock no-error.
        if  not avail unid-feder then do:
            {include/i-vldprg.i}  
            {utp/ut-liter.i UF * C}
            run utp/ut-msgs.p(input "show",
                              input 4259,
                              input trim(return-value)).
            apply 'entry' to estabelec.estado in frame {&frame-name}.
            return 'ADM-ERROR':U. 
        end.
    end.

    if  input frame {&frame-name} estabelec.ep-codigo:sensitive then do:
        FIND FIRST empresa 
             where empresa.ep-codigo  = input frame {&frame-name} estabelec.ep-codigo
             no-lock no-error.
        if  not avail empresa then do:
            run utp/ut-msgs.p(input "show",
                              input 12,
                              input string(input frame {&frame-name} estabelec.ep-codigo)).
            apply 'entry' to estabelec.ep-codigo in frame {&frame-name}.
            return 'ADM-ERROR':U.                             
        END.
    END.
                
    if  input frame {&FRAME-NAME} c-endereco = "" then do:
        {include/i-vldprg.i}  
        {utp/ut-liter.i Endereáo * C}
        run utp/ut-msgs.p (input "show",
                           input 164,
                           input trim(return-value)).
        apply 'entry' to c-endereco in frame {&frame-name}.
        return 'ADM-ERROR':U. 
    end.
            
    if  input frame {&FRAME-NAME} estabelec.cidade = "" then do:
        {include/i-vldprg.i}  
        {utp/ut-liter.i Cidade * C}
        run utp/ut-msgs.p (input "show",
                           input 164,
                           input trim(return-value)).
        apply 'entry' to estabelec.cidade in frame {&frame-name}.
        return 'ADM-ERROR':U. 
    end.
    
    if input frame {&frame-name} estabelec.grupo-aloca = "" then do:
          {utp/ut-field.i mgadm estabelec grupo-aloca 1}
          {include/i-vldprg.i}              
          run utp/ut-msgs.p (input "show",
                             input 265,
                             input return-value).
          apply 'entry' to estabelec.grupo-aloca in frame {&frame-name}.
          return 'ADM-ERROR':U.                                          
    end.
    else do:
       RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT THIS-PROCEDURE,
        INPUT "cod-estabel").
       if (input frame {&frame-name} estabelec.grupo-aloca <> return-value) and 
 /* if */ not can-find(estabelec where estabelec.cod-estabel = input frame {&frame-name} estabelec.grupo-aloca) then do:
          {include/i-vldprg.i}              
          run utp/ut-msgs.p (input "show",
                             input 777,
                             input (input frame {&frame-name} estabelec.grupo-aloca)).
          apply 'entry' to estabelec.grupo-aloca in frame {&frame-name}.
          return 'ADM-ERROR':U.                                          
       end.   
    
       if not can-find(estabelec where estabelec.cod-estabel = input frame {&frame-name} estabelec.grupo-aloca
                    and estabelec.grupo-aloca = estabelec.cod-estabel) 
       and input frame {&frame-name} estabelec.grupo-aloca  <> return-value then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                              input 17433,
                              input return-value).
            apply 'entry' to estabelec.grupo-aloca in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

	IF i-pais-impto-usuario = 1 AND TRIM(estabelec.cgc:SCREEN-VALUE) <> "" THEN DO:
	   
	   ASSIGN estabelec.cgc:FORMAT IN FRAME {&FRAME-NAME} =  param-global.formato-id-federal.
					
	   /** Valida digitaÁ„o CNPJ **/
	   ASSIGN c-cnpj = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(estabelec.cgc:SCREEN-VALUE, ".", ""), "-", ""), "/", ""), " ", "")).
	   				
	   IF LENGTH(c-cnpj) < 14 OR LENGTH(c-cnpj) > 19 THEN DO:
          {include/i-vldprg.i}
          RUN utp/ut-msgs.p ("show", 2744, "").
          APPLY "ENTRY" TO estabelec.cgc IN FRAME {&FRAME-NAME}.
          RETURN 'ADM-ERROR':U.
	   END.			
       
	   /* Foráar letras para ma°usculo */
	   ASSIGN estabelec.cgc:SCREEN-VALUE = CAPS(estabelec.cgc:SCREEN-VALUE).
		
	END.
                                    
    /*---- Verifica se o CGC j† existe para outro Estabelecimento ------*/
    RUN get-attribute ('adm-new-record').
    if  return-value = "yes":U then do:
        find first b-estabelec no-lock
             where b-estabelec.cgc = input frame {&FRAME-NAME} estabelec.cgc no-error.
        if  avail b-estabelec then do:
            if  param-global.bloqueio-cgc = 2 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 31516,
                                   input string(b-estabelec.cgc) + "~~" + 
                                         string(estabelec.cod-estabel)).
                    if  return-value = "no" then do:
                        {include/i-vldprg.i}
                        apply 'entry' to estabelec.cgc in frame {&frame-name}.
                        return "adm-error":U.
                    end.
            end.
            if  param-global.bloqueio-cgc = 3 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                  input 31515,
                                input string(b-estabelec.cgc) + "~~" +
                                     string(estabelec.cod-estabel)).
                apply 'entry' to estabelec.cgc in frame {&frame-name}.
                return "adm-error":U.
            end.
        end.
    end.
                    
    do  on error undo, return 'adm-error':
        if   input frame {&FRAME-NAME} estabelec.pais = "BRASIL" then do:   
            run cdp/cd6666.p (input input frame {&FRAME-NAME} estabelec.cgc, input 2).
            if  return-value = 'NOK' then do:               
                {include/i-vldprg.i}
                apply 'entry' to estabelec.cgc in frame {&frame-name}.
                return "adm-error":U.
            end.
                
            assign c-cep-aux2 = string(int(input frame {&frame-name} c-cep)) no-error.
            if c-cep-aux2 = "" or c-cep-aux2 = "0" then do:
               {include/i-vldprg.i}        
               run utp/ut-msgs.p (input "show", input 192, input "").
               apply 'entry' to c-cep.
               return "adm-error".
            end.
        END.
    end. 

    IF CAN-FIND(FIRST pais 
                WHERE pais.nome-pais = INPUT FRAME {&FRAME-NAME} estabelec.pais 
                AND   pais.int-2     <> 1) THEN DO:
       IF NOT VALID-HANDLE(h-cdapi704) THEN
          RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
    
       RUN pi-trata-endereco IN h-cdapi704 (INPUT INPUT FRAME {&FRAME-NAME} c-endereco, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).
    
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
                             pais.nome-pais = INPUT FRAME {&FRAME-NAME} estabelec.pais AND
                             pais.int-2     = 2) THEN DO: /* Advertencia */
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "Formato_do_endereáo_do_estabelecimento_desconhecido._Deseja_continuar?" *}
               RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT  27100,
                                 INPUT RETURN-VALUE + "~~" + c-help).
    
                IF RETURN-VALUE = "NO":U THEN DO:
                  APPLY "ENTRY" TO c-endereco IN FRAME f-main.
                  RETURN 'adm-error':U.
               END.
           END.
     
           IF CAN-FIND(FIRST pais WHERE 
                             pais.nome-pais = INPUT FRAME {&FRAME-NAME} estabelec.pais AND
                             pais.int-2     = 3) THEN DO: /* Com Bloqueio */
               /* Inicio -- Projeto Internacional */
               {utp/ut-liter.i "Formato_do_endereáo_do_estabelecimento_inv†lido" *}
               RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT  17006,
                                 INPUT RETURN-VALUE + "." + "~~" + c-help).
               APPLY "ENTRY" TO c-endereco IN FRAME f-main.
               RETURN 'adm-error':U.
           END.
        END.
    END.

    IF INPUT FRAME {&FRAME-NAME} estabelec.pais = "BRASIL" 
    AND NOT CAN-FIND(FIRST serie
                     WHERE serie.serie = INPUT FRAME {&FRAME-NAME} c-serie-nfse) THEN DO:

        {utp/ut-liter.i SÇrie * C}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 2,
                           INPUT TRIM(RETURN-VALUE)).
        APPLY 'entry' TO c-serie-nfse IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR':U. 
    END.
        
    if  i-pais-impto-usuario = 9 AND 
        (input frame {&FRAME-NAME} c-cod-fiscal-estab = "" OR 
         input frame {&FRAME-NAME} c-cod-fiscal-estab = 000) then do:

        {include/i-vldprg.i}  
        {utp/ut-liter.i C¢d._Fiscal_Estabelec * C}
        run utp/ut-msgs.p (input "show",
                           input 265,
                           input trim(return-value)).
        apply 'entry' to c-cod-fiscal-estab in frame {&frame-name}.
        return 'ADM-ERROR':U. 
    end. 

        
    IF i-pais-impto-usuario = 33 /*Peru*/ AND
       LENGTH(c-zip-cod:FORMAT IN FRAME {&FRAME-NAME}) <> 
       LENGTH(c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME}) AND 
          c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO: 
          
        ASSIGN c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME} =  FILL("0", LENGTH(c-zip-cod:FORMAT IN FRAME {&FRAME-NAME}) - LENGTH(c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME})) + c-zip-cod:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
             
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
  {src/adm/template/snd-list.i "estabelec"}

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


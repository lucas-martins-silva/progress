{include/i-prgvrs.i ANEUT200 2.00.00.001} /* 08/11/2024 15:31:07 */

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEUT200 MUT}
&ENDIF


&IF "{&mguni_dbtype}" = "Progress":U &THEN
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgind            PROGRESS
          mguni            PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-ini AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-fim AS CHARACTER  NO-UNDO INIT "999999".
{adapters/neogrid/utp/aneut200.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME b-b2b-item-fornec-erp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-b2b-item-fornec tt-cliente emitente ~
tt-cond-pagto cond-pagto tt-fornec tt-item item tt-item-fornec tt-moeda ~
moeda tt-natur-oper natur-oper tt-Serie serie tt-tab-unidade tab-unidade ~
tt-transporte transporte tt-via-transporte via-transporte

/* Definitions for BROWSE b-b2b-item-fornec-erp                         */
&Scoped-define FIELDS-IN-QUERY-b-b2b-item-fornec-erp tt-b2b-item-fornec.it-codigo tt-b2b-item-fornec.cod-emitente   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-b2b-item-fornec-erp   
&Scoped-define SELF-NAME b-b2b-item-fornec-erp
&Scoped-define OPEN-QUERY-b-b2b-item-fornec-erp OPEN QUERY {&SELF-NAME} FOR EACH tt-b2b-item-fornec NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-b2b-item-fornec-erp tt-b2b-item-fornec
&Scoped-define FIRST-TABLE-IN-QUERY-b-b2b-item-fornec-erp tt-b2b-item-fornec


/* Definitions for BROWSE b-cliente                                     */
&Scoped-define FIELDS-IN-QUERY-b-cliente tt-cliente.cod-emitente tt-cliente.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-cliente   
&Scoped-define SELF-NAME b-cliente
&Scoped-define OPEN-QUERY-b-cliente OPEN QUERY {&SELF-NAME} FOR EACH tt-cliente.
&Scoped-define TABLES-IN-QUERY-b-cliente tt-cliente
&Scoped-define FIRST-TABLE-IN-QUERY-b-cliente tt-cliente


/* Definitions for BROWSE b-cliente-erp                                 */
&Scoped-define FIELDS-IN-QUERY-b-cliente-erp emitente.cod-emitente ~
emitente.nome-abrev emitente.nome-emit 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-cliente-erp 
&Scoped-define OPEN-QUERY-b-cliente-erp OPEN QUERY b-cliente-erp FOR EACH emitente ~
      WHERE emitente.cod-emitente >= int(c-ini) ~
 AND emitente.cod-emitente <= int(c-fim) ~
 AND (mgadm.emitente.identific = 1 ~
 OR emitente.identific = 3) NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-cliente-erp emitente
&Scoped-define FIRST-TABLE-IN-QUERY-b-cliente-erp emitente


/* Definitions for BROWSE b-cond-pagto                                  */
&Scoped-define FIELDS-IN-QUERY-b-cond-pagto tt-cond-pagto.cod-cond-pag tt-cond-pagto.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-cond-pagto   
&Scoped-define SELF-NAME b-cond-pagto
&Scoped-define OPEN-QUERY-b-cond-pagto OPEN QUERY {&SELF-NAME} FOR EACH tt-cond-pagto.
&Scoped-define TABLES-IN-QUERY-b-cond-pagto tt-cond-pagto
&Scoped-define FIRST-TABLE-IN-QUERY-b-cond-pagto tt-cond-pagto


/* Definitions for BROWSE b-cond-pagto-erp                              */
&Scoped-define FIELDS-IN-QUERY-b-cond-pagto-erp cond-pagto.cod-cond-pag ~
cond-pagto.descricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-cond-pagto-erp 
&Scoped-define OPEN-QUERY-b-cond-pagto-erp OPEN QUERY b-cond-pagto-erp FOR EACH cond-pagto ~
      WHERE cond-pagto.cod-cond-pag >= int(c-ini) ~
 AND cond-pagto.cod-cond-pag <= int(c-fim) NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-cond-pagto-erp cond-pagto
&Scoped-define FIRST-TABLE-IN-QUERY-b-cond-pagto-erp cond-pagto


/* Definitions for BROWSE b-fornec                                      */
&Scoped-define FIELDS-IN-QUERY-b-fornec tt-fornec.cod-emitente tt-fornec.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-fornec   
&Scoped-define SELF-NAME b-fornec
&Scoped-define OPEN-QUERY-b-fornec OPEN QUERY {&SELF-NAME} FOR EACH tt-fornec.
&Scoped-define TABLES-IN-QUERY-b-fornec tt-fornec
&Scoped-define FIRST-TABLE-IN-QUERY-b-fornec tt-fornec


/* Definitions for BROWSE b-Fornec-erp                                  */
&Scoped-define FIELDS-IN-QUERY-b-Fornec-erp emitente.cod-emitente ~
emitente.nome-abrev emitente.nome-emit 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-Fornec-erp 
&Scoped-define OPEN-QUERY-b-Fornec-erp OPEN QUERY b-Fornec-erp FOR EACH emitente ~
      WHERE emitente.cod-emitente >= int(c-ini) ~
 AND emitente.cod-emitente <= int(c-fim) ~
 AND (mgadm.emitente.identific = 2 ~
 OR emitente.identific = 3) NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-Fornec-erp emitente
&Scoped-define FIRST-TABLE-IN-QUERY-b-Fornec-erp emitente


/* Definitions for BROWSE b-item                                        */
&Scoped-define FIELDS-IN-QUERY-b-item tt-item.it-codigo tt-item.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-item   
&Scoped-define SELF-NAME b-item
&Scoped-define OPEN-QUERY-b-item OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
&Scoped-define TABLES-IN-QUERY-b-item tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-b-item tt-item


/* Definitions for BROWSE b-item-erp                                    */
&Scoped-define FIELDS-IN-QUERY-b-item-erp item.it-codigo item.desc-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-item-erp 
&Scoped-define OPEN-QUERY-b-item-erp OPEN QUERY b-item-erp FOR EACH item ~
      WHERE (item.ind-item-fat = YES ~
or item.compr-fabric = 1) ~
and item.it-codigo >= c-ini ~
and item.it-codigo <= c-fim NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-item-erp item
&Scoped-define FIRST-TABLE-IN-QUERY-b-item-erp item


/* Definitions for BROWSE b-item-fornec                                 */
&Scoped-define FIELDS-IN-QUERY-b-item-fornec tt-item-fornec.it-codigo tt-item-fornec.cod-emitente   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-item-fornec   
&Scoped-define SELF-NAME b-item-fornec
&Scoped-define OPEN-QUERY-b-item-fornec OPEN QUERY {&SELF-NAME} FOR EACH tt-item-fornec.
&Scoped-define TABLES-IN-QUERY-b-item-fornec tt-item-fornec
&Scoped-define FIRST-TABLE-IN-QUERY-b-item-fornec tt-item-fornec


/* Definitions for BROWSE b-Moeda                                       */
&Scoped-define FIELDS-IN-QUERY-b-Moeda tt-moeda.mo-codigo tt-moeda.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-Moeda   
&Scoped-define SELF-NAME b-Moeda
&Scoped-define OPEN-QUERY-b-Moeda OPEN QUERY {&SELF-NAME} FOR EACH tt-moeda.
&Scoped-define TABLES-IN-QUERY-b-Moeda tt-moeda
&Scoped-define FIRST-TABLE-IN-QUERY-b-Moeda tt-moeda


/* Definitions for BROWSE b-moeda-erp                                   */
&Scoped-define FIELDS-IN-QUERY-b-moeda-erp moeda.mo-codigo moeda.descricao ~
moeda.sigla 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-moeda-erp 
&Scoped-define OPEN-QUERY-b-moeda-erp OPEN QUERY b-moeda-erp FOR EACH moeda ~
      WHERE moeda.mo-codigo >= int(c-ini) ~
 AND moeda.mo-codigo <= int(c-fim) NO-LOCK.
&Scoped-define TABLES-IN-QUERY-b-moeda-erp moeda
&Scoped-define FIRST-TABLE-IN-QUERY-b-moeda-erp moeda


/* Definitions for BROWSE b-natur-oper                                  */
&Scoped-define FIELDS-IN-QUERY-b-natur-oper tt-natur-oper.nat-operacao tt-natur-oper.denominacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-natur-oper   
&Scoped-define SELF-NAME b-natur-oper
&Scoped-define OPEN-QUERY-b-natur-oper OPEN QUERY {&SELF-NAME} FOR EACH tt-natur-oper.
&Scoped-define TABLES-IN-QUERY-b-natur-oper tt-natur-oper
&Scoped-define FIRST-TABLE-IN-QUERY-b-natur-oper tt-natur-oper


/* Definitions for BROWSE b-natur-oper-erp                              */
&Scoped-define FIELDS-IN-QUERY-b-natur-oper-erp natur-oper.nat-operacao ~
natur-oper.denominacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-natur-oper-erp 
&Scoped-define OPEN-QUERY-b-natur-oper-erp OPEN QUERY b-natur-oper-erp FOR EACH natur-oper ~
      WHERE natur-oper.nat-operacao >= c-ini ~
 AND natur-oper.nat-operacao <= c-fim NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-natur-oper-erp natur-oper
&Scoped-define FIRST-TABLE-IN-QUERY-b-natur-oper-erp natur-oper


/* Definitions for BROWSE b-Serie                                       */
&Scoped-define FIELDS-IN-QUERY-b-Serie tt-serie.serie   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-Serie   
&Scoped-define SELF-NAME b-Serie
&Scoped-define OPEN-QUERY-b-Serie OPEN QUERY {&SELF-NAME} FOR EACH tt-Serie.
&Scoped-define TABLES-IN-QUERY-b-Serie tt-Serie
&Scoped-define FIRST-TABLE-IN-QUERY-b-Serie tt-Serie


/* Definitions for BROWSE b-Serie-erp                                   */
&Scoped-define FIELDS-IN-QUERY-b-Serie-erp serie.serie serie.serie-vinc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-Serie-erp 
&Scoped-define OPEN-QUERY-b-Serie-erp OPEN QUERY b-Serie-erp FOR EACH serie ~
      WHERE serie.serie >= c-ini ~
 AND serie.serie <= c-fim NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-Serie-erp serie
&Scoped-define FIRST-TABLE-IN-QUERY-b-Serie-erp serie


/* Definitions for BROWSE b-tab-unidade                                 */
&Scoped-define FIELDS-IN-QUERY-b-tab-unidade tt-tab-unidade.un tt-tab-unidade.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-tab-unidade   
&Scoped-define SELF-NAME b-tab-unidade
&Scoped-define OPEN-QUERY-b-tab-unidade OPEN QUERY {&SELF-NAME} FOR EACH tt-tab-unidade.
&Scoped-define TABLES-IN-QUERY-b-tab-unidade tt-tab-unidade
&Scoped-define FIRST-TABLE-IN-QUERY-b-tab-unidade tt-tab-unidade


/* Definitions for BROWSE b-Tab-unidade-erp                             */
&Scoped-define FIELDS-IN-QUERY-b-Tab-unidade-erp tab-unidade.un ~
tab-unidade.descricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-Tab-unidade-erp 
&Scoped-define OPEN-QUERY-b-Tab-unidade-erp OPEN QUERY b-Tab-unidade-erp FOR EACH tab-unidade ~
      WHERE tab-unidade.un >= c-ini ~
 AND tab-unidade.un <= c-fim NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-Tab-unidade-erp tab-unidade
&Scoped-define FIRST-TABLE-IN-QUERY-b-Tab-unidade-erp tab-unidade


/* Definitions for BROWSE b-transporte                                  */
&Scoped-define FIELDS-IN-QUERY-b-transporte tt-transporte.cod-transp tt-transporte.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-transporte   
&Scoped-define SELF-NAME b-transporte
&Scoped-define OPEN-QUERY-b-transporte OPEN QUERY {&SELF-NAME} FOR EACH tt-transporte.
&Scoped-define TABLES-IN-QUERY-b-transporte tt-transporte
&Scoped-define FIRST-TABLE-IN-QUERY-b-transporte tt-transporte


/* Definitions for BROWSE b-Transporte-erp                              */
&Scoped-define FIELDS-IN-QUERY-b-Transporte-erp transporte.cod-transp ~
transporte.nome-abrev 
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-Transporte-erp 
&Scoped-define OPEN-QUERY-b-Transporte-erp OPEN QUERY b-Transporte-erp FOR EACH transporte ~
      WHERE Transporte.cod-transp >= Int(c-ini) ~
       AND Transporte.cod-transp <= int(c-fim) NO-LOCK.
&Scoped-define TABLES-IN-QUERY-b-Transporte-erp transporte
&Scoped-define FIRST-TABLE-IN-QUERY-b-Transporte-erp transporte


/* Definitions for BROWSE b-via-transporte                              */
&Scoped-define FIELDS-IN-QUERY-b-via-transporte tt-via-transporte.cod-via tt-via-transporte.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-via-transporte   
&Scoped-define SELF-NAME b-via-transporte
&Scoped-define OPEN-QUERY-b-via-transporte OPEN QUERY {&SELF-NAME} FOR EACH tt-via-transporte.
&Scoped-define TABLES-IN-QUERY-b-via-transporte tt-via-transporte
&Scoped-define FIRST-TABLE-IN-QUERY-b-via-transporte tt-via-transporte


/* Definitions for BROWSE b-Via-Transporte-erp                          */
&Scoped-define FIELDS-IN-QUERY-b-Via-Transporte-erp via-transporte.cod-via via-transporte.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-b-Via-Transporte-erp   
&Scoped-define SELF-NAME b-Via-Transporte-erp
&Scoped-define OPEN-QUERY-b-Via-Transporte-erp OPEN QUERY {&SELF-NAME} FOR EACH via-transporte       WHERE via-transporte.cod-via >= int(c-ini)  AND via-transporte.cod-via <= int(c-fim) NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-b-Via-Transporte-erp via-transporte
&Scoped-define FIRST-TABLE-IN-QUERY-b-Via-Transporte-erp via-transporte


/* Definitions for FRAME F-Cliente                                      */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Cliente ~
    ~{&OPEN-QUERY-b-cliente}~
    ~{&OPEN-QUERY-b-cliente-erp}

/* Definitions for FRAME F-cond-pagto                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-cond-pagto ~
    ~{&OPEN-QUERY-b-cond-pagto}~
    ~{&OPEN-QUERY-b-cond-pagto-erp}

/* Definitions for FRAME f-fornec                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-fornec ~
    ~{&OPEN-QUERY-b-fornec}~
    ~{&OPEN-QUERY-b-Fornec-erp}

/* Definitions for FRAME F-item                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-item ~
    ~{&OPEN-QUERY-b-item}~
    ~{&OPEN-QUERY-b-item-erp}

/* Definitions for FRAME F-item-fornec                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-item-fornec ~
    ~{&OPEN-QUERY-b-b2b-item-fornec-erp}~
    ~{&OPEN-QUERY-b-item-fornec}

/* Definitions for FRAME f-moeda                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-moeda ~
    ~{&OPEN-QUERY-b-Moeda}~
    ~{&OPEN-QUERY-b-moeda-erp}

/* Definitions for FRAME F-natur-oper                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-natur-oper ~
    ~{&OPEN-QUERY-b-natur-oper}~
    ~{&OPEN-QUERY-b-natur-oper-erp}

/* Definitions for FRAME f-serie                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-serie ~
    ~{&OPEN-QUERY-b-Serie}~
    ~{&OPEN-QUERY-b-Serie-erp}

/* Definitions for FRAME f-tab-unidade                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-tab-unidade ~
    ~{&OPEN-QUERY-b-tab-unidade}~
    ~{&OPEN-QUERY-b-Tab-unidade-erp}

/* Definitions for FRAME F-transporte                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-transporte ~
    ~{&OPEN-QUERY-b-transporte}~
    ~{&OPEN-QUERY-b-Transporte-erp}

/* Definitions for FRAME f-via-transporte                               */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-via-transporte ~
    ~{&OPEN-QUERY-b-via-transporte}~
    ~{&OPEN-QUERY-b-Via-Transporte-erp}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 tg-option bt-close bt-close-2 ~
RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS tg-option 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-close 
     LABEL "Enviar NG" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-close-2 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "image/gr-fil.bmp":U
     LABEL "Button 2" 
     SIZE 5 BY 1.13 TOOLTIP "Filtro".

DEFINE VARIABLE tg-option AS CHARACTER FORMAT "X(256)":U INITIAL "Condiá∆o de Pagtos" 
     LABEL "Cadastros" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Condiá∆o de Pagtos","Natureza de Operaá∆o","Unidade de Medida","Serie","Moeda","Item","Transportadora","Cliente ","Fornecedor","MÇtodo Transporte","Item Fornecedor" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 91 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 91 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON Bt-addallcliente 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addcliente 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delallcliente 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delcliente 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallcond 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addcondpagto 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelallCond 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelCondpagto 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallFornec 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addcliente-2 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delallcliente-2 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delcliente-2 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallitem 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-additem 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delallitem 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delitem 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallitemfornec 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-additemfornec 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delallitemfornec 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delitemfornec 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallMoeda 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addMoeda 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelallMoeda 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelMoeda 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallnatur 
     LABEL ">>|" 
     SIZE 6 BY 1.5 TOOLTIP "Envia tudo".

DEFINE BUTTON Bt-addcondpagto-2 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelCondpagto-2 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelCondpagto-3 
     LABEL "|<<" 
     SIZE 6 BY 1.5 TOOLTIP "Remove Tudo".

DEFINE VARIABLE c-resultado AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 89 BY 11 NO-UNDO.

DEFINE BUTTON Bt-addallSeries 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addSeries 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelallSeries 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelSeries 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallUnidade 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addUnidade 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelallUnidade 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelUnidade 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallTransporte 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addTransporte 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelallTransporte 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-DelTrasnporte 
     LABEL "<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addallvia 
     LABEL ">>|" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-addvia-transporte 
     LABEL ">" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delallvia 
     LABEL "|<<" 
     SIZE 6 BY 1.5.

DEFINE BUTTON Bt-Delvia-transporte 
     LABEL "<" 
     SIZE 6 BY 1.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY b-b2b-item-fornec-erp FOR 
      tt-b2b-item-fornec SCROLLING.

DEFINE QUERY b-cliente FOR 
      tt-cliente SCROLLING.

DEFINE QUERY b-cliente-erp FOR 
      emitente SCROLLING.

DEFINE QUERY b-cond-pagto FOR 
      tt-cond-pagto SCROLLING.

DEFINE QUERY b-cond-pagto-erp FOR 
      cond-pagto SCROLLING.

DEFINE QUERY b-fornec FOR 
      tt-fornec SCROLLING.

DEFINE QUERY b-Fornec-erp FOR 
      emitente SCROLLING.

DEFINE QUERY b-item FOR 
      tt-item SCROLLING.

DEFINE QUERY b-item-erp FOR 
      item SCROLLING.

DEFINE QUERY b-item-fornec FOR 
      tt-item-fornec SCROLLING.

DEFINE QUERY b-Moeda FOR 
      tt-moeda SCROLLING.

DEFINE QUERY b-moeda-erp FOR 
      moeda SCROLLING.

DEFINE QUERY b-natur-oper FOR 
      tt-natur-oper SCROLLING.

DEFINE QUERY b-natur-oper-erp FOR 
      natur-oper SCROLLING.

DEFINE QUERY b-Serie FOR 
      tt-Serie SCROLLING.

DEFINE QUERY b-Serie-erp FOR 
      serie SCROLLING.

DEFINE QUERY b-tab-unidade FOR 
      tt-tab-unidade SCROLLING.

DEFINE QUERY b-Tab-unidade-erp FOR 
      tab-unidade SCROLLING.

DEFINE QUERY b-transporte FOR 
      tt-transporte SCROLLING.

DEFINE QUERY b-Transporte-erp FOR 
      transporte SCROLLING.

DEFINE QUERY b-via-transporte FOR 
      tt-via-transporte SCROLLING.

DEFINE QUERY b-Via-Transporte-erp FOR 
      via-transporte SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE b-b2b-item-fornec-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-b2b-item-fornec-erp C-Win _FREEFORM
  QUERY b-b2b-item-fornec-erp NO-LOCK DISPLAY
      tt-b2b-item-fornec.it-codigo FORMAT "x(16)":U
      tt-b2b-item-fornec.cod-emitente LABEL 'Fornecedor'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .6 EXPANDABLE.

DEFINE BROWSE b-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cliente C-Win _FREEFORM
  QUERY b-cliente DISPLAY
      tt-cliente.cod-emitente
 tt-cliente.nome-abrev
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .67 EXPANDABLE.

DEFINE BROWSE b-cliente-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cliente-erp C-Win _STRUCTURED
  QUERY b-cliente-erp NO-LOCK DISPLAY
      emitente.cod-emitente FORMAT ">>>>>>>>9":U WIDTH 10
      emitente.nome-abrev FORMAT "X(12)":U WIDTH 12.43
      emitente.nome-emit FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cond-pagto C-Win _FREEFORM
  QUERY b-cond-pagto DISPLAY
      tt-cond-pagto.cod-cond-pag
 tt-cond-pagto.descricao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-cond-pagto-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-cond-pagto-erp C-Win _STRUCTURED
  QUERY b-cond-pagto-erp NO-LOCK DISPLAY
      cond-pagto.cod-cond-pag FORMAT ">>9":U
      cond-pagto.descricao FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-fornec C-Win _FREEFORM
  QUERY b-fornec DISPLAY
      tt-fornec.cod-emitente
 tt-fornec.nome-abrev
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-Fornec-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-Fornec-erp C-Win _STRUCTURED
  QUERY b-Fornec-erp NO-LOCK DISPLAY
      emitente.cod-emitente FORMAT ">>>>>>>>9":U WIDTH 10
      emitente.nome-abrev FORMAT "X(12)":U WIDTH 12.43
      emitente.nome-emit FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-item C-Win _FREEFORM
  QUERY b-item DISPLAY
      tt-item.it-codigo
     tt-item.desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-item-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-item-erp C-Win _STRUCTURED
  QUERY b-item-erp NO-LOCK DISPLAY
      item.it-codigo FORMAT "x(16)":U
      item.desc-item FORMAT "x(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-item-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-item-fornec C-Win _FREEFORM
  QUERY b-item-fornec DISPLAY
      tt-item-fornec.it-codigo
     tt-item-fornec.cod-emitente
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-Moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-Moeda C-Win _FREEFORM
  QUERY b-Moeda DISPLAY
      tt-moeda.mo-codigo
      tt-moeda.descricao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-moeda-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-moeda-erp C-Win _STRUCTURED
  QUERY b-moeda-erp NO-LOCK DISPLAY
      moeda.mo-codigo FORMAT ">9":U
      moeda.descricao FORMAT "x(12)":U
      moeda.sigla FORMAT "x(04)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-natur-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-natur-oper C-Win _FREEFORM
  QUERY b-natur-oper DISPLAY
      tt-natur-oper.nat-operacao
 tt-natur-oper.denominacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-natur-oper-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-natur-oper-erp C-Win _STRUCTURED
  QUERY b-natur-oper-erp NO-LOCK DISPLAY
      natur-oper.nat-operacao FORMAT "9.99-XXX":U
      natur-oper.denominacao FORMAT "x(35)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-Serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-Serie C-Win _FREEFORM
  QUERY b-Serie DISPLAY
      tt-serie.serie
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-Serie-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-Serie-erp C-Win _STRUCTURED
  QUERY b-Serie-erp NO-LOCK DISPLAY
      serie.serie FORMAT "x(5)":U WIDTH 10
      serie.serie-vinc FORMAT "x(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-tab-unidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-tab-unidade C-Win _FREEFORM
  QUERY b-tab-unidade DISPLAY
      tt-tab-unidade.un
      tt-tab-unidade.descricao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-Tab-unidade-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-Tab-unidade-erp C-Win _STRUCTURED
  QUERY b-Tab-unidade-erp NO-LOCK DISPLAY
      tab-unidade.un FORMAT "xx":U
      tab-unidade.descricao FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-transporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-transporte C-Win _FREEFORM
  QUERY b-transporte DISPLAY
      tt-transporte.cod-transp
      tt-transporte.nome-abrev
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-Transporte-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-Transporte-erp C-Win _STRUCTURED
  QUERY b-Transporte-erp NO-LOCK DISPLAY
      transporte.cod-transp FORMAT ">>,>>9":U
      transporte.nome-abrev FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-via-transporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-via-transporte C-Win _FREEFORM
  QUERY b-via-transporte DISPLAY
      tt-via-transporte.cod-via
 tt-via-transporte.descricao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 40 BY 10.54 ROW-HEIGHT-CHARS .65 EXPANDABLE.

DEFINE BROWSE b-Via-Transporte-erp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS b-Via-Transporte-erp C-Win _FREEFORM
  QUERY b-Via-Transporte-erp NO-LOCK DISPLAY
      via-transporte.cod-via FORMAT ">>9":U
      via-transporte.descricao FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.57 BY 10.5 ROW-HEIGHT-CHARS .65 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BUTTON-2 AT ROW 1.21 COL 40.29
     tg-option AT ROW 1.25 COL 5.43
     bt-close AT ROW 15.75 COL 3
     bt-close-2 AT ROW 15.75 COL 17
     RECT-1 AT ROW 1 COL 2
     RECT-2 AT ROW 15.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 93.14 BY 16.29.

DEFINE FRAME f-tab-unidade
     b-Tab-unidade-erp AT ROW 1.71 COL 2.43
     b-tab-unidade AT ROW 1.71 COL 50
     Bt-addallUnidade AT ROW 3 COL 43
     Bt-addUnidade AT ROW 4.79 COL 43
     Bt-DelUnidade AT ROW 6.63 COL 43
     Bt-DelallUnidade AT ROW 8.5 COL 43
     "Unidade p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
     "Unidade de Medidas no Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Unidade de Medidas".

DEFINE FRAME F-cond-pagto
     b-cond-pagto-erp AT ROW 1.71 COL 2.43
     b-cond-pagto AT ROW 1.71 COL 50
     Bt-addallcond AT ROW 3 COL 43
     Bt-addcondpagto AT ROW 4.79 COL 43
     Bt-DelCondpagto AT ROW 6.63 COL 43
     Bt-DelallCond AT ROW 8.5 COL 43
     "Condiá‰es p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
     "Condiá‰es disponiveis no Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Condiá∆o de Pagtos".

DEFINE FRAME f-fornec
     b-Fornec-erp AT ROW 1.71 COL 2.43
     b-fornec AT ROW 1.71 COL 50
     Bt-addallFornec AT ROW 3 COL 43
     Bt-addcliente-2 AT ROW 4.79 COL 43
     Bt-Delcliente-2 AT ROW 6.63 COL 43
     Bt-Delallcliente-2 AT ROW 8.5 COL 43
     "Fornecedores p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
     "Fornecedores disponiveis no ERP" VIEW-AS TEXT
          SIZE 33 BY .67 AT ROW 1 COL 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Fornecedor".

DEFINE FRAME F-Cliente
     b-cliente-erp AT ROW 1.71 COL 2.43
     b-cliente AT ROW 1.71 COL 50
     Bt-addallcliente AT ROW 3 COL 43
     Bt-addcliente AT ROW 4.79 COL 43
     Bt-Delcliente AT ROW 6.63 COL 43
     Bt-Delallcliente AT ROW 8.5 COL 43
     "Clientes p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
     "Clientes disponiveis no ERP" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Cliente".

DEFINE FRAME F-item
     b-item-erp AT ROW 1.71 COL 2.43
     b-item AT ROW 1.71 COL 50
     Bt-addallitem AT ROW 3 COL 43
     Bt-additem AT ROW 4.79 COL 43
     Bt-Delitem AT ROW 6.63 COL 43
     Bt-Delallitem AT ROW 8.5 COL 43
     "Item no Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
     "Item p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Item".

DEFINE FRAME f-resultado
     c-resultado AT ROW 1.25 COL 2 NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Log".

DEFINE FRAME F-natur-oper
     b-natur-oper-erp AT ROW 1.71 COL 2.43
     b-natur-oper AT ROW 1.71 COL 50
     Bt-addallnatur AT ROW 3 COL 43
     Bt-addcondpagto-2 AT ROW 4.71 COL 43
     Bt-DelCondpagto-2 AT ROW 6.46 COL 43
     Bt-DelCondpagto-3 AT ROW 8.25 COL 43
     "Naturezas disponiveis no Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
     "Naturezas p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Natureza de Operaá‰es".

DEFINE FRAME F-item-fornec
     b-b2b-item-fornec-erp AT ROW 1.71 COL 2.43
     b-item-fornec AT ROW 1.71 COL 50
     Bt-addallitemfornec AT ROW 3 COL 43
     Bt-additemfornec AT ROW 4.79 COL 43
     Bt-Delitemfornec AT ROW 6.63 COL 43
     Bt-Delallitemfornec AT ROW 8.5 COL 43
     "Item no Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
     "Item p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Item Fornecedor".

DEFINE FRAME f-via-transporte
     b-Via-Transporte-erp AT ROW 1.71 COL 2.43
     b-via-transporte AT ROW 1.71 COL 50
     Bt-addallvia AT ROW 3 COL 43
     Bt-addvia-transporte AT ROW 4.79 COL 43
     Bt-Delvia-transporte AT ROW 6.63 COL 43
     Bt-Delallvia AT ROW 8.5 COL 43
     "MÇtodos do Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
     "MÇtodos p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "MÇtodo Transporte".

DEFINE FRAME F-transporte
     b-Transporte-erp AT ROW 1.71 COL 2.43
     b-transporte AT ROW 1.71 COL 50
     Bt-addallTransporte AT ROW 3 COL 43
     Bt-addTransporte AT ROW 4.79 COL 43
     Bt-DelTrasnporte AT ROW 6.63 COL 43
     Bt-DelallTransporte AT ROW 8.5 COL 43
     "Transportadora no Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
     "Transportadora p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Transportadoras".

DEFINE FRAME f-moeda
     b-moeda-erp AT ROW 1.71 COL 2.43
     b-Moeda AT ROW 1.71 COL 50
     Bt-addallMoeda AT ROW 3 COL 43
     Bt-addMoeda AT ROW 4.79 COL 43
     Bt-DelMoeda AT ROW 6.63 COL 43
     Bt-DelallMoeda AT ROW 8.5 COL 43
     "Moeda do Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
     "Moeda p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "Moeda".

DEFINE FRAME f-serie
     b-Serie-erp AT ROW 1.71 COL 2.43
     b-Serie AT ROW 1.71 COL 50
     Bt-addallSeries AT ROW 3 COL 43
     Bt-addSeries AT ROW 4.79 COL 43
     Bt-DelSeries AT ROW 6.63 COL 43
     Bt-DelallSeries AT ROW 8.5 COL 43
     "SÇries p/ envio B2B" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 59
     "SÇries do Erp" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1 COL 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3
         SIZE 91 BY 12.25
         TITLE "SÇries".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Implanta B2B"
         HEIGHT             = 16.21
         WIDTH              = 93.57
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("image/emsrpc.ico":U) THEN
    MESSAGE "Unable to load icon: image/emsrpc.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME F-Cliente:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME F-cond-pagto:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-fornec:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME F-item:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME F-item-fornec:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-moeda:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME F-natur-oper:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-resultado:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-serie:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-tab-unidade:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME F-transporte:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME f-via-transporte:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR COMBO-BOX tg-option IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME F-Cliente
                                                                        */
/* BROWSE-TAB b-cliente-erp 1 F-Cliente */
/* BROWSE-TAB b-cliente b-cliente-erp F-Cliente */
/* SETTINGS FOR FRAME F-cond-pagto
                                                                        */
/* BROWSE-TAB b-cond-pagto-erp 1 F-cond-pagto */
/* BROWSE-TAB b-cond-pagto b-cond-pagto-erp F-cond-pagto */
/* SETTINGS FOR FRAME f-fornec
                                                                        */
/* BROWSE-TAB b-Fornec-erp 1 f-fornec */
/* BROWSE-TAB b-fornec b-Fornec-erp f-fornec */
/* SETTINGS FOR FRAME F-item
                                                                        */
/* BROWSE-TAB b-item-erp 1 F-item */
/* BROWSE-TAB b-item b-item-erp F-item */
/* SETTINGS FOR FRAME F-item-fornec
                                                                        */
/* BROWSE-TAB b-b2b-item-fornec-erp 1 F-item-fornec */
/* BROWSE-TAB b-item-fornec b-b2b-item-fornec-erp F-item-fornec */
/* SETTINGS FOR FRAME f-moeda
   NOT-VISIBLE                                                          */
/* BROWSE-TAB b-moeda-erp 1 f-moeda */
/* BROWSE-TAB b-Moeda b-moeda-erp f-moeda */
/* SETTINGS FOR FRAME F-natur-oper
                                                                        */
/* BROWSE-TAB b-natur-oper-erp 1 F-natur-oper */
/* BROWSE-TAB b-natur-oper b-natur-oper-erp F-natur-oper */
/* SETTINGS FOR FRAME f-resultado
                                                                        */
ASSIGN 
       FRAME f-resultado:HIDDEN           = TRUE.

ASSIGN 
       c-resultado:AUTO-INDENT IN FRAME f-resultado      = TRUE.

/* SETTINGS FOR FRAME f-serie
                                                                        */
/* BROWSE-TAB b-Serie-erp 1 f-serie */
/* BROWSE-TAB b-Serie b-Serie-erp f-serie */
/* SETTINGS FOR FRAME f-tab-unidade
                                                                        */
/* BROWSE-TAB b-Tab-unidade-erp 1 f-tab-unidade */
/* BROWSE-TAB b-tab-unidade b-Tab-unidade-erp f-tab-unidade */
/* SETTINGS FOR FRAME F-transporte
                                                                        */
/* BROWSE-TAB b-Transporte-erp 1 F-transporte */
/* BROWSE-TAB b-transporte b-Transporte-erp F-transporte */
/* SETTINGS FOR FRAME f-via-transporte
                                                                        */
/* BROWSE-TAB b-Via-Transporte-erp 1 f-via-transporte */
/* BROWSE-TAB b-via-transporte b-Via-Transporte-erp f-via-transporte */
ASSIGN 
       Bt-addvia-transporte:HIDDEN IN FRAME f-via-transporte           = TRUE.

ASSIGN 
       Bt-Delvia-transporte:HIDDEN IN FRAME f-via-transporte           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-b2b-item-fornec-erp
/* Query rebuild information for BROWSE b-b2b-item-fornec-erp
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-b2b-item-fornec NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE b-b2b-item-fornec-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-cliente
/* Query rebuild information for BROWSE b-cliente
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cliente.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-cliente */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-cliente-erp
/* Query rebuild information for BROWSE b-cliente-erp
     _TblList          = "mgadm.emitente"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgadm.emitente.cod-emitente >= int(c-ini)
 AND mgadm.emitente.cod-emitente <= int(c-fim)
 AND (mgadm.emitente.identific = 1
 OR mgadm.emitente.identific = 3)"
     _FldNameList[1]   > mgadm.emitente.cod-emitente
"emitente.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[2]   > mgadm.emitente.nome-abrev
"emitente.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" ""
     _FldNameList[3]   = mgadm.emitente.nome-emit
     _Query            is OPENED
*/  /* BROWSE b-cliente-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-cond-pagto
/* Query rebuild information for BROWSE b-cond-pagto
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cond-pagto.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-cond-pagto */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-cond-pagto-erp
/* Query rebuild information for BROWSE b-cond-pagto-erp
     _TblList          = "mgadm.cond-pagto"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgadm.cond-pagto.cod-cond-pag >= int(c-ini)
 AND mgadm.cond-pagto.cod-cond-pag <= int(c-fim)"
     _FldNameList[1]   = mgadm.cond-pagto.cod-cond-pag
     _FldNameList[2]   = mgadm.cond-pagto.descricao
     _Query            is OPENED
*/  /* BROWSE b-cond-pagto-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-fornec
/* Query rebuild information for BROWSE b-fornec
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-fornec.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-fornec */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-Fornec-erp
/* Query rebuild information for BROWSE b-Fornec-erp
     _TblList          = "mgadm.emitente"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgadm.emitente.cod-emitente >= int(c-ini)
 AND mgadm.emitente.cod-emitente <= int(c-fim)
 AND (mgadm.emitente.identific = 2
 OR mgadm.emitente.identific = 3)"
     _FldNameList[1]   > mgadm.emitente.cod-emitente
"emitente.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[2]   > mgadm.emitente.nome-abrev
"emitente.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" ""
     _FldNameList[3]   = mgadm.emitente.nome-emit
     _Query            is OPENED
*/  /* BROWSE b-Fornec-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-item
/* Query rebuild information for BROWSE b-item
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-item */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-item-erp
/* Query rebuild information for BROWSE b-item-erp
     _TblList          = "mgind.item"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "(item.ind-item-fat = YES
or item.compr-fabric = 1)
and item.it-codigo >= c-ini
and item.it-codigo <= c-fim"
     _FldNameList[1]   = mgind.item.it-codigo
     _FldNameList[2]   = mgind.item.desc-item
     _Query            is OPENED
*/  /* BROWSE b-item-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-item-fornec
/* Query rebuild information for BROWSE b-item-fornec
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-fornec.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-item-fornec */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-Moeda
/* Query rebuild information for BROWSE b-Moeda
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-moeda.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-Moeda */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-moeda-erp
/* Query rebuild information for BROWSE b-moeda-erp
     _TblList          = "mguni.moeda"
     _Options          = "NO-LOCK"
     _Where[1]         = "mguni.moeda.mo-codigo >= int(c-ini)
 AND mguni.moeda.mo-codigo <= int(c-fim)"
     _FldNameList[1]   = mguni.moeda.mo-codigo
     _FldNameList[2]   = mguni.moeda.descricao
     _FldNameList[3]   = mguni.moeda.sigla
     _Query            is OPENED
*/  /* BROWSE b-moeda-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-natur-oper
/* Query rebuild information for BROWSE b-natur-oper
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-natur-oper.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-natur-oper */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-natur-oper-erp
/* Query rebuild information for BROWSE b-natur-oper-erp
     _TblList          = "mgind.natur-oper"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgind.natur-oper.nat-operacao >= c-ini
 AND mgind.natur-oper.nat-operacao <= c-fim"
     _FldNameList[1]   = mgind.natur-oper.nat-operacao
     _FldNameList[2]   = mgind.natur-oper.denominacao
     _Query            is OPENED
*/  /* BROWSE b-natur-oper-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-Serie
/* Query rebuild information for BROWSE b-Serie
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-Serie.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-Serie */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-Serie-erp
/* Query rebuild information for BROWSE b-Serie-erp
     _TblList          = "mgind.serie"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgind.serie.serie >= c-ini
 AND mgind.serie.serie <= c-fim"
     _FldNameList[1]   > mgind.serie.serie
"serie.serie" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[2]   = mgind.serie.serie-vinc
     _Query            is OPENED
*/  /* BROWSE b-Serie-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-tab-unidade
/* Query rebuild information for BROWSE b-tab-unidade
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-tab-unidade.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-tab-unidade */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-Tab-unidade-erp
/* Query rebuild information for BROWSE b-Tab-unidade-erp
     _TblList          = "mgind.tab-unidade"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgind.tab-unidade.un >= c-ini
 AND mgind.tab-unidade.un <= c-fim"
     _FldNameList[1]   = mgind.tab-unidade.un
     _FldNameList[2]   = mgind.tab-unidade.descricao
     _Query            is OPENED
*/  /* BROWSE b-Tab-unidade-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-transporte
/* Query rebuild information for BROWSE b-transporte
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-transporte.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-transporte */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-Transporte-erp
/* Query rebuild information for BROWSE b-Transporte-erp
     _TblList          = "mgadm.transporte"
     _Options          = "NO-LOCK"
     _Where[1]         = "Transporte.cod-transp >= Int(c-ini)
       AND Transporte.cod-transp <= int(c-fim)"
     _FldNameList[1]   = mgadm.transporte.cod-transp
     _FldNameList[2]   = mgadm.transporte.nome-abrev
     _Query            is OPENED
*/  /* BROWSE b-Transporte-erp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-via-transporte
/* Query rebuild information for BROWSE b-via-transporte
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-via-transporte.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE b-via-transporte */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE b-Via-Transporte-erp
/* Query rebuild information for BROWSE b-Via-Transporte-erp
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH via-transporte
      WHERE via-transporte.cod-via >= int(c-ini)
 AND via-transporte.cod-via <= int(c-fim) NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgadm.cond-pagto.cod-cond-pag >= int(c-ini)
 AND mgadm.cond-pagto.cod-cond-pag <= int(c-fim)"
     _Query            is OPENED
*/  /* BROWSE b-Via-Transporte-erp */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Implanta B2B */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Implanta B2B */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-Cliente
&Scoped-define SELF-NAME Bt-addallcliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallcliente C-Win
ON CHOOSE OF Bt-addallcliente IN FRAME F-Cliente /* >>| */
DO:
  
  FOR EACH emitente 
      WHERE mgadm.emitente.cod-emitente >= int(c-ini)
        AND mgadm.emitente.cod-emitente <= int(c-fim)   
        AND (mgadm.emitente.identific = 1
         OR mgadm.emitente.identific = 3) NO-LOCK:

    FIND tt-cliente WHERE tt-cliente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-cliente  THEN DO:
        CREATE tt-cliente.
        ASSIGN tt-cliente.cod-emitente =  emitente.cod-emitente
               tt-cliente.nome-abrev   = emitente.nome-abrev.
        
    END.
  END.
  OPEN QUERY b-cliente FOR EACH tt-cliente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-cond-pagto
&Scoped-define SELF-NAME Bt-addallcond
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallcond C-Win
ON CHOOSE OF Bt-addallcond IN FRAME F-cond-pagto /* >>| */
DO:
  
  FOR EACH cond-pagto   WHERE mgadm.cond-pagto.cod-cond-pag >= int(c-ini)
 AND mgadm.cond-pagto.cod-cond-pag <= int(c-fim) NO-LOCK:

    FIND tt-cond-pagto WHERE tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-cond-pagto  THEN DO:
        CREATE tt-cond-pagto.
        BUFFER-COPY cond-pagto TO tt-cond-pagto.
        
    END.
  END.
  OPEN QUERY b-cond-pagto FOR EACH tt-cond-pagto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-fornec
&Scoped-define SELF-NAME Bt-addallFornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallFornec C-Win
ON CHOOSE OF Bt-addallFornec IN FRAME f-fornec /* >>| */
DO:
  
  FOR EACH emitente 
      WHERE mgadm.emitente.cod-emitente >= int(c-ini)
        AND mgadm.emitente.cod-emitente <= int(c-fim)   
        AND (mgadm.emitente.identific = 2
         OR mgadm.emitente.identific = 3) NO-LOCK:

    FIND tt-fornec WHERE tt-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-fornec  THEN DO:
        CREATE tt-fornec.
        ASSIGN tt-fornec.cod-emitente =  emitente.cod-emitente
               tt-fornec.nome-abrev   = emitente.nome-abrev.
    END.

  END.
  OPEN QUERY b-fornec FOR EACH tt-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item
&Scoped-define SELF-NAME Bt-addallitem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallitem C-Win
ON CHOOSE OF Bt-addallitem IN FRAME F-item /* >>| */
DO:
  
 FOR EACH item   
     WHERE item.un >= c-ini
       AND item.Un <= c-fim NO-LOCK:

    FIND tt-item WHERE tt-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-item  THEN DO:
        CREATE tt-item.
        BUFFER-COPY item TO tt-item.
        
    END.
  END.
  OPEN QUERY b-item FOR EACH tt-item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item-fornec
&Scoped-define SELF-NAME Bt-addallitemfornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallitemfornec C-Win
ON CHOOSE OF Bt-addallitemfornec IN FRAME F-item-fornec /* >>| */
DO:
  
 FOR EACH tt-b2b-item-fornec   
     WHERE tt-b2b-item-fornec.it-codigo >= c-ini
       AND tt-b2b-item-fornec.it-codigo <= c-fim NO-LOCK:

    FIND tt-item-fornec WHERE tt-item-fornec.it-codigo    = tt-b2b-item-fornec.it-codigo 
                          AND tt-item-fornec.cod-emitente = tt-b2b-item-fornec.cod-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-item-fornec  THEN DO:
        CREATE tt-item-fornec.
        BUFFER-COPY tt-b2b-item-fornec TO tt-item-fornec.
    END.
  END.
  OPEN QUERY b-item-fornec FOR EACH tt-item-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-moeda
&Scoped-define SELF-NAME Bt-addallMoeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallMoeda C-Win
ON CHOOSE OF Bt-addallMoeda IN FRAME f-moeda /* >>| */
DO:
  
 FOR EACH Moeda   
     WHERE Moeda.Mo-codigo >= int(c-ini)
       AND Moeda.Mo-codigo <= int(c-fim) NO-LOCK:

    FIND tt-Moeda WHERE tt-Moeda.Mo-codigo = Moeda.Mo-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-Moeda  THEN DO:
        CREATE tt-Moeda.
        BUFFER-COPY Moeda TO tt-Moeda.
        
    END.
  END.
  OPEN QUERY b-Moeda FOR EACH tt-Moeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-natur-oper
&Scoped-define SELF-NAME Bt-addallnatur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallnatur C-Win
ON CHOOSE OF Bt-addallnatur IN FRAME F-natur-oper /* >>| */
DO:
  
 FOR EACH natur-oper WHERE natur-oper.nat-operacao >= c-ini
 AND natur-oper.nat-operacao <= c-fim NO-LOCK :
    FIND tt-natur-oper WHERE tt-natur-oper.nat-operacao = natur-oper.nat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-natur-oper  THEN DO:
        CREATE tt-natur-oper.
        BUFFER-COPY natur-oper TO tt-natur-oper.
  
    END.
  END.
  OPEN QUERY b-natur-oper FOR EACH tt-natur-oper.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-serie
&Scoped-define SELF-NAME Bt-addallSeries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallSeries C-Win
ON CHOOSE OF Bt-addallSeries IN FRAME f-serie /* >>| */
DO:
  
 FOR EACH Serie   
     WHERE Serie.Serie >= c-ini
       AND Serie.Serie <= c-fim NO-LOCK:

    FIND tt-Serie WHERE tt-Serie.Serie = Serie.Serie NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-Serie  THEN DO:
        CREATE tt-Serie.
        BUFFER-COPY Serie TO tt-Serie.
        
    END.
  END.
  OPEN QUERY b-Serie FOR EACH tt-Serie.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-transporte
&Scoped-define SELF-NAME Bt-addallTransporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallTransporte C-Win
ON CHOOSE OF Bt-addallTransporte IN FRAME F-transporte /* >>| */
DO:
  
 FOR EACH Transporte   
     WHERE Transporte.cod-transp >= Int(c-ini)
       AND Transporte.cod-transp <= int(c-fim) NO-LOCK:

    FIND tt-transporte WHERE tt-transporte.cod-transp = transporte.cod-transp NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-transporte  THEN DO:
        CREATE tt-transporte.
        BUFFER-COPY transporte TO tt-transporte.
    END.
  END.
  OPEN QUERY b-Transporte FOR EACH tt-transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-tab-unidade
&Scoped-define SELF-NAME Bt-addallUnidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallUnidade C-Win
ON CHOOSE OF Bt-addallUnidade IN FRAME f-tab-unidade /* >>| */
DO:
  
 FOR EACH tab-unidade   
     WHERE tab-unidade.un >= c-ini
       AND tab-unidade.Un <= c-fim NO-LOCK:

    FIND tt-tab-unidade WHERE tt-tab-unidade.un = tab-unidade.un NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-tab-unidade  THEN DO:
        CREATE tt-tab-unidade.
        BUFFER-COPY tab-unidade TO tt-tab-unidade.
        
    END.
  END.
  OPEN QUERY b-tab-unidade FOR EACH tt-tab-unidade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-via-transporte
&Scoped-define SELF-NAME Bt-addallvia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addallvia C-Win
ON CHOOSE OF Bt-addallvia IN FRAME f-via-transporte /* >>| */
DO:
  
  FOR EACH via-transporte   WHERE via-transporte.cod-via >= int(c-ini)
 AND via-transporte.cod-via <= int(c-fim) NO-LOCK:

    FIND tt-via-transporte WHERE tt-via-transporte.cod-via = via-transporte.cod-via NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-via-transporte  THEN DO:
        CREATE tt-via-transporte.
        BUFFER-COPY via-transporte TO tt-via-transporte.
        
    END.
  END.
  OPEN QUERY b-via-transporte FOR EACH tt-via-transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-Cliente
&Scoped-define SELF-NAME Bt-addcliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addcliente C-Win
ON CHOOSE OF Bt-addcliente IN FRAME F-Cliente /* > */
DO:
  
 DO i = 1 TO B-cliente-erp:NUM-SELECTED-ROWS:
     b-cliente-erp:FETCH-SELECTED-ROW( i ).
    FIND tt-cliente WHERE tt-cliente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-cliente  THEN DO:
        CREATE tt-cliente.
        BUFFER-COPY emitente TO tt-cliente.
        
    END.

  END.
  OPEN QUERY b-cliente FOR EACH tt-cliente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-fornec
&Scoped-define SELF-NAME Bt-addcliente-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addcliente-2 C-Win
ON CHOOSE OF Bt-addcliente-2 IN FRAME f-fornec /* > */
DO:
  
 DO i = 1 TO B-fornec-erp:NUM-SELECTED-ROWS:
     b-fornec-erp:FETCH-SELECTED-ROW( i ).
    FIND tt-fornec WHERE tt-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-fornec  THEN DO:
        CREATE tt-fornec.
        BUFFER-COPY emitente TO tt-fornec.
        
    END.

  END.
  OPEN QUERY b-fornec FOR EACH tt-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-cond-pagto
&Scoped-define SELF-NAME Bt-addcondpagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addcondpagto C-Win
ON CHOOSE OF Bt-addcondpagto IN FRAME F-cond-pagto /* > */
DO:
  
 DO i = 1 TO B-cond-pagto-erp:NUM-SELECTED-ROWS:
             b-cond-pagto-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-cond-pagto WHERE tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-cond-pagto  THEN DO:
        CREATE tt-cond-pagto.
        BUFFER-COPY cond-pagto TO tt-cond-pagto.
        OPEN QUERY b-cond-pagto FOR EACH tt-cond-pagto.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-natur-oper
&Scoped-define SELF-NAME Bt-addcondpagto-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addcondpagto-2 C-Win
ON CHOOSE OF Bt-addcondpagto-2 IN FRAME F-natur-oper /* > */
DO:
  
 DO i = 1 TO B-natur-oper-erp:NUM-SELECTED-ROWS:
             b-natur-oper-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-natur-oper WHERE tt-natur-oper.nat-operacao = natur-oper.nat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-natur-oper  THEN DO:
        CREATE tt-natur-oper.
        BUFFER-COPY natur-oper TO tt-natur-oper.
        OPEN QUERY b-natur-oper FOR EACH tt-natur-oper.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item
&Scoped-define SELF-NAME Bt-additem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-additem C-Win
ON CHOOSE OF Bt-additem IN FRAME F-item /* > */
DO:
  
 DO i = 1 TO B-item-erp:NUM-SELECTED-ROWS:
             b-item-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-item WHERE tt-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-item  THEN DO:
        CREATE tt-item.
        BUFFER-COPY item TO tt-item.
    END.
  END.
  OPEN QUERY b-item FOR EACH tt-item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item-fornec
&Scoped-define SELF-NAME Bt-additemfornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-additemfornec C-Win
ON CHOOSE OF Bt-additemfornec IN FRAME F-item-fornec /* > */
DO:
  
 DO i = 1 TO B-b2b-item-fornec-erp:NUM-SELECTED-ROWS:
             b-b2b-item-fornec-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-item-fornec WHERE tt-item-fornec.it-codigo = tt-b2b-item-fornec.it-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-item-fornec  THEN DO:
        CREATE tt-item-fornec.
        BUFFER-COPY tt-b2b-item-fornec TO tt-item-fornec.
    END.
  END.
  OPEN QUERY b-item-fornec FOR EACH tt-item-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-moeda
&Scoped-define SELF-NAME Bt-addMoeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addMoeda C-Win
ON CHOOSE OF Bt-addMoeda IN FRAME f-moeda /* > */
DO:
  
 DO i = 1 TO B-Moeda-erp:NUM-SELECTED-ROWS:
             b-Moeda-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-Moeda WHERE tt-Moeda.Mo-codigo = Moeda.Mo-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-Moeda  THEN DO:
        CREATE tt-Moeda.
        BUFFER-COPY Moeda TO tt-Moeda.
        OPEN QUERY b-Moeda FOR EACH tt-Moeda.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-serie
&Scoped-define SELF-NAME Bt-addSeries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addSeries C-Win
ON CHOOSE OF Bt-addSeries IN FRAME f-serie /* > */
DO:
  
 DO i = 1 TO B-Serie-erp:NUM-SELECTED-ROWS:
             b-Serie-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-Serie WHERE tt-Serie.Serie = Serie.Serie NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-Serie  THEN DO:
        CREATE tt-Serie.
        BUFFER-COPY Serie TO tt-Serie.
        OPEN QUERY b-Serie FOR EACH tt-Serie.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-transporte
&Scoped-define SELF-NAME Bt-addTransporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addTransporte C-Win
ON CHOOSE OF Bt-addTransporte IN FRAME F-transporte /* > */
DO:
  
 DO i = 1 TO B-Transporte-erp:NUM-SELECTED-ROWS:
             b-Transporte-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-Transporte WHERE tt-Transporte.cod-transp = Transporte.cod-transp NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-Transporte  THEN DO:
        CREATE tt-Transporte.
        BUFFER-COPY Transporte TO tt-Transporte.
        OPEN QUERY b-Transporte FOR EACH tt-Transporte.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-tab-unidade
&Scoped-define SELF-NAME Bt-addUnidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addUnidade C-Win
ON CHOOSE OF Bt-addUnidade IN FRAME f-tab-unidade /* > */
DO:
  
 DO i = 1 TO B-tab-unidade-erp:NUM-SELECTED-ROWS:
             b-tab-unidade-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-tab-unidade WHERE tt-tab-unidade.un = tab-unidade.un NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-tab-unidade  THEN DO:
        CREATE tt-tab-unidade.
        BUFFER-COPY tab-unidade TO tt-tab-unidade.
        OPEN QUERY b-tab-unidade FOR EACH tt-tab-unidade.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-via-transporte
&Scoped-define SELF-NAME Bt-addvia-transporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-addvia-transporte C-Win
ON CHOOSE OF Bt-addvia-transporte IN FRAME f-via-transporte /* > */
DO:
  
 DO i = 1 TO B-via-transporte-erp:NUM-SELECTED-ROWS:
             b-via-transporte-erp:FETCH-SELECTED-ROW( i ).

    FIND tt-via-transporte WHERE tt-via-transporte.cod-via = via-transporte.cod-via NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-via-transporte  THEN DO:
        CREATE tt-via-transporte.
        BUFFER-COPY via-transporte TO tt-via-transporte.
        OPEN QUERY b-via-transporte FOR EACH tt-via-transporte.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME bt-close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-close C-Win
ON CHOOSE OF bt-close IN FRAME DEFAULT-FRAME /* Enviar NG */
DO:
/*IF SESSION:SET-WAIT-STATE("general") THEN.*/
  HIDE FRAME f-cond-pagto.
  HIDE FRAME f-moeda.
  HIDE FRAME f-transporte.
  HIDE FRAME f-natur-oper.
  HIDE FRAME f-cliente.
  HIDE FRAME f-fornec.
  HIDE FRAME f-resultado.
  HIDE FRAME f-tab-unidade.
  HIDE FRAME f-Serie.
  HIDE FRAME f-item.
  VIEW FRAME f-resultado.
  
  RUN pi-envia-ng.
  RUN pi-deleta-tt.
  
/*  IF SESSION:SET-WAIT-STATE("") THEN.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-close-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-close-2 C-Win
ON CHOOSE OF bt-close-2 IN FRAME DEFAULT-FRAME /* Fechar */
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-Cliente
&Scoped-define SELF-NAME Bt-Delallcliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delallcliente C-Win
ON CHOOSE OF Bt-Delallcliente IN FRAME F-Cliente /* |<< */
DO:
  FOR EACH tt-cliente:
       DELETE tt-cliente.
  END.
  OPEN QUERY b-cliente FOR EACH tt-cliente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-fornec
&Scoped-define SELF-NAME Bt-Delallcliente-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delallcliente-2 C-Win
ON CHOOSE OF Bt-Delallcliente-2 IN FRAME f-fornec /* |<< */
DO:
  FOR EACH tt-fornec:
       DELETE tt-fornec.
  END.
  OPEN QUERY b-fornec FOR EACH tt-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-cond-pagto
&Scoped-define SELF-NAME Bt-DelallCond
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelallCond C-Win
ON CHOOSE OF Bt-DelallCond IN FRAME F-cond-pagto /* |<< */
DO:
  FOR EACH tt-cond-pagto:
       DELETE tt-cond-pagto.
  END.
  OPEN QUERY b-cond-pagto FOR EACH tt-cond-pagto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item
&Scoped-define SELF-NAME Bt-Delallitem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delallitem C-Win
ON CHOOSE OF Bt-Delallitem IN FRAME F-item /* |<< */
DO:
  FOR EACH tt-item:
       DELETE tt-item.
  END.
  OPEN QUERY b-item FOR EACH tt-item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item-fornec
&Scoped-define SELF-NAME Bt-Delallitemfornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delallitemfornec C-Win
ON CHOOSE OF Bt-Delallitemfornec IN FRAME F-item-fornec /* |<< */
DO:
  FOR EACH tt-item-fornec:
       DELETE tt-item-fornec.
  END.
  OPEN QUERY b-item-fornec FOR EACH tt-item-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-moeda
&Scoped-define SELF-NAME Bt-DelallMoeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelallMoeda C-Win
ON CHOOSE OF Bt-DelallMoeda IN FRAME f-moeda /* |<< */
DO:
  FOR EACH tt-Moeda:
       DELETE tt-Moeda.
  END.
  OPEN QUERY b-Moeda FOR EACH tt-Moeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-serie
&Scoped-define SELF-NAME Bt-DelallSeries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelallSeries C-Win
ON CHOOSE OF Bt-DelallSeries IN FRAME f-serie /* |<< */
DO:
  FOR EACH tt-Serie:
       DELETE tt-Serie.
  END.
  OPEN QUERY b-Serie FOR EACH tt-Serie.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-transporte
&Scoped-define SELF-NAME Bt-DelallTransporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelallTransporte C-Win
ON CHOOSE OF Bt-DelallTransporte IN FRAME F-transporte /* |<< */
DO:
  FOR EACH tt-Transporte:
       DELETE tt-Transporte.
  END.
  OPEN QUERY b-Transporte FOR EACH tt-Transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-tab-unidade
&Scoped-define SELF-NAME Bt-DelallUnidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelallUnidade C-Win
ON CHOOSE OF Bt-DelallUnidade IN FRAME f-tab-unidade /* |<< */
DO:
  FOR EACH tt-tab-unidade:
       DELETE tt-tab-unidade.
  END.
  OPEN QUERY b-tab-unidade FOR EACH tt-tab-unidade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-via-transporte
&Scoped-define SELF-NAME Bt-Delallvia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delallvia C-Win
ON CHOOSE OF Bt-Delallvia IN FRAME f-via-transporte /* |<< */
DO:
  FOR EACH tt-via-transporte:
       DELETE tt-via-transporte.
  END.
  OPEN QUERY b-via-transporte FOR EACH tt-via-transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-Cliente
&Scoped-define SELF-NAME Bt-Delcliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delcliente C-Win
ON CHOOSE OF Bt-Delcliente IN FRAME F-Cliente /* < */
DO:
   DO i = 1 TO B-cliente:NUM-SELECTED-ROWS:
             b-cliente:FETCH-SELECTED-ROW( i ).
        DELETE tt-cliente.

   END.
   OPEN QUERY b-cliente FOR EACH tt-cliente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-fornec
&Scoped-define SELF-NAME Bt-Delcliente-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delcliente-2 C-Win
ON CHOOSE OF Bt-Delcliente-2 IN FRAME f-fornec /* < */
DO:
   DO i = 1 TO B-fornec:NUM-SELECTED-ROWS:
             b-fornec:FETCH-SELECTED-ROW( i ).
        DELETE tt-fornec.

   END.
   OPEN QUERY b-fornec FOR EACH tt-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-cond-pagto
&Scoped-define SELF-NAME Bt-DelCondpagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelCondpagto C-Win
ON CHOOSE OF Bt-DelCondpagto IN FRAME F-cond-pagto /* < */
DO:
   DO i = 1 TO B-cond-pagto:NUM-SELECTED-ROWS:
        b-cond-pagto:FETCH-SELECTED-ROW( i ).
        DELETE tt-cond-pagto.

   END.
   OPEN QUERY b-cond-pagto FOR EACH tt-cond-pagto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-natur-oper
&Scoped-define SELF-NAME Bt-DelCondpagto-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelCondpagto-2 C-Win
ON CHOOSE OF Bt-DelCondpagto-2 IN FRAME F-natur-oper /* < */
DO:
   DO i = 1 TO B-natur-oper:NUM-SELECTED-ROWS:
             b-natur-oper:FETCH-SELECTED-ROW( i ).
        DELETE tt-natur-oper.

   END.
   OPEN QUERY b-natur-oper FOR EACH tt-natur-oper.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bt-DelCondpagto-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelCondpagto-3 C-Win
ON CHOOSE OF Bt-DelCondpagto-3 IN FRAME F-natur-oper /* |<< */
DO:
  FOR EACH tt-natur-oper:
          DELETE tt-natur-oper.
  END.
   OPEN QUERY b-natur-oper FOR EACH tt-natur-oper.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item
&Scoped-define SELF-NAME Bt-Delitem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delitem C-Win
ON CHOOSE OF Bt-Delitem IN FRAME F-item /* < */
DO:
   DO i = 1 TO B-item:NUM-SELECTED-ROWS:
             b-item:FETCH-SELECTED-ROW( i ).
        DELETE tt-item.

   END.
   OPEN QUERY b-item FOR EACH tt-item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-item-fornec
&Scoped-define SELF-NAME Bt-Delitemfornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delitemfornec C-Win
ON CHOOSE OF Bt-Delitemfornec IN FRAME F-item-fornec /* < */
DO:
   DO i = 1 TO B-item-fornec:NUM-SELECTED-ROWS:
             b-item-fornec:FETCH-SELECTED-ROW( i ).
        DELETE tt-item-fornec.

   END.
   OPEN QUERY b-item-fornec FOR EACH tt-item-fornec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-moeda
&Scoped-define SELF-NAME Bt-DelMoeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelMoeda C-Win
ON CHOOSE OF Bt-DelMoeda IN FRAME f-moeda /* < */
DO:
   DO i = 1 TO B-Moeda:NUM-SELECTED-ROWS:
             b-Moeda:FETCH-SELECTED-ROW( i ).
        DELETE tt-Moeda.

   END.
   OPEN QUERY b-Moeda FOR EACH tt-Moeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-serie
&Scoped-define SELF-NAME Bt-DelSeries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelSeries C-Win
ON CHOOSE OF Bt-DelSeries IN FRAME f-serie /* < */
DO:
   DO i = 1 TO B-Serie:NUM-SELECTED-ROWS:
             b-Serie:FETCH-SELECTED-ROW( i ).
        DELETE tt-Serie.

   END.
   OPEN QUERY b-Serie FOR EACH tt-Serie.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME F-transporte
&Scoped-define SELF-NAME Bt-DelTrasnporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelTrasnporte C-Win
ON CHOOSE OF Bt-DelTrasnporte IN FRAME F-transporte /* < */
DO:
   DO i = 1 TO B-Transporte:NUM-SELECTED-ROWS:
             b-Transporte:FETCH-SELECTED-ROW( i ).
        DELETE tt-Transporte.

   END.
   OPEN QUERY b-Transporte FOR EACH tt-Transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-tab-unidade
&Scoped-define SELF-NAME Bt-DelUnidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-DelUnidade C-Win
ON CHOOSE OF Bt-DelUnidade IN FRAME f-tab-unidade /* < */
DO:
   DO i = 1 TO B-tab-unidade:NUM-SELECTED-ROWS:
               b-tab-unidade:FETCH-SELECTED-ROW( i ).
        DELETE tt-tab-unidade.

   END.
   OPEN QUERY b-tab-unidade FOR EACH tt-tab-unidade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-via-transporte
&Scoped-define SELF-NAME Bt-Delvia-transporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Delvia-transporte C-Win
ON CHOOSE OF Bt-Delvia-transporte IN FRAME f-via-transporte /* < */
DO:
   DO i = 1 TO B-via-transporte:NUM-SELECTED-ROWS:
             b-via-transporte:FETCH-SELECTED-ROW( i ).
        DELETE tt-via-transporte.

   END.
   OPEN QUERY b-via-transporte FOR EACH tt-via-transporte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 C-Win
ON CHOOSE OF BUTTON-2 IN FRAME DEFAULT-FRAME /* Button 2 */
DO:
    CASE INPUT FRAME {&FRAME-NAME} tg-option:
        WHEN 'Condiá∆o de Pagtos' THEN DO:
            RUN adapters\neogrid\utp\aneut200a.w (INPUT "Condiá∆o de Pagtos,x(3),i", 
                                                  OUTPUT c-ini,
                                                  OUTPUT c-fim ).
            {&OPEN-QUERY-b-cond-pagto-erp}

        END.
        WHEN 'Natureza de Operaá∆o' THEN DO:
            RUN adapters\neogrid\utp\aneut200a.w (INPUT "Natureza de Operaá∆o,x(6),c", 
                                          OUTPUT c-ini,
                                          OUTPUT c-fim ).
            {&OPEN-QUERY-b-natur-oper-erp}
        END.
         
        WHEN 'Cliente' THEN DO:
            RUN adapters\neogrid\utp\aneut200a.w (INPUT "Cliente,x(9),i", 
                                          OUTPUT c-ini,
                                          OUTPUT c-fim ).
            {&OPEN-QUERY-b-cliente-erp}
        END.
        WHEN 'fornecedor' THEN DO:
            RUN adapters\neogrid\utp\aneut200a.w (INPUT "Fornecedor,x(9),i", 
                                          OUTPUT c-ini,
                                          OUTPUT c-fim ).
            {&OPEN-QUERY-b-fornec-erp}
        END.
        WHEN 'Unidade de Medida' THEN DO:
              RUN adapters\neogrid\utp\aneut200a.w (INPUT "Unidade de Medida,XX,c", 
                                            OUTPUT c-ini,
                                            OUTPUT c-fim ).
              {&OPEN-QUERY-b-tab-unidade-erp}
        END.
        WHEN 'Transportadora' THEN DO:
              RUN adapters\neogrid\utp\aneut200a.w (INPUT "Transportadora,x(9),i", 
                                            OUTPUT c-ini,
                                            OUTPUT c-fim ).
              {&OPEN-QUERY-b-Transporte-erp}
        END.
        WHEN 'Serie' THEN DO:
              RUN adapters\neogrid\utp\aneut200a.w (INPUT "Serie,XXXXX,C", 
                                            OUTPUT c-ini,
                                            OUTPUT c-fim ).
              {&OPEN-QUERY-b-Serie-erp}
        END.  

        WHEN 'Moeda' THEN DO:
              RUN adapters\neogrid\utp\aneut200a.w (INPUT "Moeda,XX,i", 
                                            OUTPUT c-ini,
                                            OUTPUT c-fim ).
              {&OPEN-QUERY-b-Moeda-erp}
        END.  
        WHEN 'Item' THEN DO:
              RUN adapters\neogrid\utp\aneut200a.w (INPUT "Item,x(16),c", 
                                            OUTPUT c-ini,
                                            OUTPUT c-fim ).
              {&OPEN-QUERY-b-item-erp}
        END.  
        WHEN 'MÇtodo Transporte' THEN DO:
              RUN adapters\neogrid\utp\aneut200a.w (INPUT "MÇtodo de Transporte,XX,i", 
                                            OUTPUT c-ini,
                                            OUTPUT c-fim ).
              {&OPEN-QUERY-b-via-transporte-erp}
        END.  


    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-option
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-option C-Win
ON VALUE-CHANGED OF tg-option IN FRAME DEFAULT-FRAME /* Cadastros */
DO:
    HIDE FRAME f-cond-pagto.
    HIDE FRAME f-moeda.
    HIDE FRAME f-transporte.
    HIDE FRAME f-natur-oper.
    HIDE FRAME f-cliente.
    HIDE FRAME f-fornec.
    HIDE FRAME f-resultado.
    HIDE FRAME f-tab-unidade.
    HIDE FRAME f-Serie.
    HIDE FRAME f-item.
    HIDE FRAME f-via-transporte.
    HIDE FRAME f-item-fornec.

    IF INDEX("Condiá∆o de Pagtos Cliente fornecedor MÇtodo Transporte Transportadora Moeda",
             INPUT FRAME {&FRAME-NAME} {&SELF-NAME} ) <> 0  
       THEN ASSIGN c-ini = "0" c-fim = "999999999".
       ELSE ASSIGN c-ini = "" c-fim = "ZZZZZZZZZZZZ".


    CASE INPUT FRAME {&FRAME-NAME} {&SELF-NAME}:
        WHEN 'Condiá∆o de Pagtos' THEN DO:
             VIEW FRAME f-cond-pagto.
        END.
        WHEN 'Natureza de Operaá∆o'  THEN DO:
            VIEW FRAME f-natur-oper.
        END.
        WHEN 'Cliente'  THEN DO:
            VIEW FRAME f-cliente.
        END.

        WHEN 'Fornecedor'  THEN DO:
            VIEW FRAME f-fornec.
        END.
        WHEN 'Unidade de Medida' THEN DO:
             VIEW FRAME f-tab-unidade.
             {&OPEN-QUERY-b-tab-unidade-erp}
        END.
        WHEN 'Transportadora' THEN DO:
             VIEW FRAME f-transporte.
        END.
        WHEN 'Serie' THEN DO:
             VIEW FRAME f-Serie.
             {&OPEN-QUERY-b-Serie-erp}
        END.  
        WHEN 'Moeda' THEN DO:
             VIEW FRAME f-moeda.
        END.
        WHEN 'Item' THEN DO:
             VIEW FRAME f-item.
        END.
        WHEN 'MÇtodo Transporte' THEN DO:
             VIEW FRAME f-via-transporte .
        END.
        WHEN 'Item Fornecedor' THEN DO:
             VIEW FRAME f-item-fornec.
             FOR EACH emitente WHERE emitente.identific <> 1 
                 AND substr(emitente.char-1,11,1) = '1' NO-LOCK: 
                 FOR EACH item-fornec OF emitente NO-LOCK :
                     FIND tt-b2b-item-fornec WHERE tt-b2b-item-fornec.it-codigo = item-fornec.it-codigo 
                                           AND tt-b2b-item-fornec.cod-emitente = item-fornec.cod-emitente NO-LOCK NO-ERROR.
                     IF NOT AVAIL tt-b2b-item-fornec THEN CREATE tt-b2b-item-fornec.
                     BUFFER-COPY item-fornec TO tt-b2b-item-fornec NO-ERROR.
                 END.
             END.
             FOR EACH tt-fornec:
                FIND emitente WHERE emitente.cod-emitente = tt-fornec.cod-emitente NO-LOCK NO-ERROR.
                 FOR EACH item-fornec OF emitente NO-LOCK :
                     FIND tt-b2b-item-fornec WHERE tt-b2b-item-fornec.it-codigo = item-fornec.it-codigo 
                                           AND tt-b2b-item-fornec.cod-emitente = item-fornec.cod-emitente NO-LOCK NO-ERROR.
                     IF NOT AVAIL tt-b2b-item-fornec THEN CREATE tt-b2b-item-fornec.
                     BUFFER-COPY item-fornec TO tt-b2b-item-fornec NO-ERROR.
                 END.
            END.
            {&OPEN-QUERY-b-b2b-item-fornec-erp}
        END.
     END CASE.
        
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME b-b2b-item-fornec-erp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY "value-changed" TO tg-option.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY tg-option 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE BUTTON-2 tg-option bt-close bt-close-2 RECT-1 RECT-2 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE b-cliente-erp b-cliente Bt-addallcliente Bt-addcliente Bt-Delcliente 
         Bt-Delallcliente 
      WITH FRAME F-Cliente IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Cliente}
  ENABLE b-cond-pagto-erp b-cond-pagto Bt-addallcond Bt-addcondpagto 
         Bt-DelCondpagto Bt-DelallCond 
      WITH FRAME F-cond-pagto IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-cond-pagto}
  ENABLE b-Fornec-erp b-fornec Bt-addallFornec Bt-addcliente-2 Bt-Delcliente-2 
         Bt-Delallcliente-2 
      WITH FRAME f-fornec IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-fornec}
  ENABLE b-item-erp b-item Bt-addallitem Bt-additem Bt-Delitem Bt-Delallitem 
      WITH FRAME F-item IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-item}
  ENABLE b-b2b-item-fornec-erp b-item-fornec Bt-addallitemfornec 
         Bt-additemfornec Bt-Delitemfornec Bt-Delallitemfornec 
      WITH FRAME F-item-fornec IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-item-fornec}
  ENABLE b-moeda-erp b-Moeda Bt-addallMoeda Bt-addMoeda Bt-DelMoeda 
         Bt-DelallMoeda 
      WITH FRAME f-moeda IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-moeda}
  ENABLE b-natur-oper-erp b-natur-oper Bt-addallnatur Bt-addcondpagto-2 
         Bt-DelCondpagto-2 Bt-DelCondpagto-3 
      WITH FRAME F-natur-oper IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-natur-oper}
  DISPLAY c-resultado 
      WITH FRAME f-resultado IN WINDOW C-Win.
  ENABLE c-resultado 
      WITH FRAME f-resultado IN WINDOW C-Win.
  VIEW FRAME f-resultado IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-resultado}
  ENABLE b-Serie-erp b-Serie Bt-addallSeries Bt-addSeries Bt-DelSeries 
         Bt-DelallSeries 
      WITH FRAME f-serie IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-serie}
  ENABLE b-Tab-unidade-erp b-tab-unidade Bt-addallUnidade Bt-addUnidade 
         Bt-DelUnidade Bt-DelallUnidade 
      WITH FRAME f-tab-unidade IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-tab-unidade}
  ENABLE b-Transporte-erp b-transporte Bt-addallTransporte Bt-addTransporte 
         Bt-DelTrasnporte Bt-DelallTransporte 
      WITH FRAME F-transporte IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-transporte}
  ENABLE b-Via-Transporte-erp b-via-transporte Bt-addallvia 
         Bt-addvia-transporte Bt-Delvia-transporte Bt-Delallvia 
      WITH FRAME f-via-transporte IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-via-transporte}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-deleta-tt C-Win 
PROCEDURE pi-deleta-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-cond-pagto:
        DELETE tt-cond-pagto.
    END.
    FOR EACH tt-tab-unidade:
        DELETE tt-tab-unidade.
    END.
    FOR EACH  tt-natur-oper  :
        DELETE tt-natur-oper.
    END.                     
    FOR EACH tt-cliente:
        DELETE tt-cliente. 
    END.
    FOR EACH tt-fornec  :
        DELETE tt-fornec.
    END.
    FOR EACH  tt-transporte:
        DELETE tt-transporte.
    END.
    FOR EACH  tt-Serie :
        DELETE tt-serie.
    END.
    FOR EACH  tt-moeda  :
        DELETE tt-moeda.
    END.
    FOR EACH  tt-item:
        DELETE tt-item.
    END.
    FOR EACH tt-via-transporte :
        DELETE tt-via-transporte.
    END.
    FOR EACH tt-item-fornec :
        DELETE tt-item-fornec.
    END.
    FOR each tt-b2b-item-fornec :
        DELETE tt-b2b-item-fornec.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-ng C-Win 
PROCEDURE pi-envia-ng :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DO TRANSACTION ON ERROR  UNDO,LEAVE:                         
    RUN pi-print-log (INPUT "------------------- Log Geraá∆o - "  + STRING(TIME,"HH:mm") + "------------------------------ " ).
    /*******cond pagto*******************/
    IF CAN-FIND(FIRST tt-Cond-pagto) THEN
    RUN pi-print-log ("* Condiá‰es de Pagamentos").
    FOR EACH tt-cond-pagto:
        FIND cond-pagto     
            WHERE cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.
            RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(cond-pagto),
                                             INPUT 1,
                                             INPUT "adapters/neogrid/ccp/anecc010.p").
        RUN pi-print-log(INPUT STRING(Cond-pagto.cod-cond-pag,">>9") + " - " + cond-pagto.descricao) . 
    END.
    /***********************Unidade Medida**************/
    IF CAN-FIND(FIRST tt-tab-unidade) THEN
    RUN pi-print-log( INPUT CHR(10) + " * Unidade de Medidas").
    FOR EACH tt-tab-unidade:
        FIND tab-unidade WHERE tab-unidade.un = tt-tab-unidade.Un  NO-LOCK NO-ERROR.
        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(tab-unidade),
                                             INPUT 1,
                                             INPUT "adapters/neogrid/enp/aneen006.p").

        RUN pi-print-log(INPUT String(tab-unidade.UN,"XXX") + " - " + tab-unidade.descricao) . 
    END.
    /************via-transporte    **************************************/
    IF CAN-FIND(FIRST tt-via-transporte) THEN
    RUN pi-print-log(INPUT CHR(10) + "* MÇtodo Transporte" )  .
    FOR first tt-via-transporte:
        RUN pi-print-log(INPUT "Obs: Ser† enviado todos os MÇtodos de transporte pois no EMS estes dados s∆o fixos " + CHR(10) )  .
        RUN adapters/neogrid/ftp/aneft007.p (?,
                                            INPUT 1,
                                            INPUT "adapters/neogrid/ftp/aneft006.p").
        RUN pi-print-log(String(ITEM.it-codigo,"XXXXXXXXXXXXXXXX") + " - " + ITEM.it-codigo) . 
    END.
   
    /***********************Natur-oper*******************************/
    IF CAN-FIND(FIRST tt-Natur-oper) THEN
    RUN pi-print-log (INPUT CHR(10) + " * Naturezas de Operaá‰es") .
    FOR EACH tt-natur-oper:
       FIND natur-oper WHERE natur-oper.nat-operacao = tt-natur-oper.nat-operacao NO-LOCK NO-ERROR.
       RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(natur-oper),
                                            INPUT 1,
                                            INPUT "adapters/neogrid/ftp/aneft003.p").
       RUN pi-print-log(INPUT String(Natur-oper.nat-operacao,"XXXXXX") + " - " + natur-oper.denominacao) . 

    END.
    /**************Cliente*************************/
    IF CAN-FIND(FIRST tt-cliente) THEN
    RUN pi-print-log(INPUT  CHR(10) + " * Clientes") .
    FOR EACH  tt-cliente:
        FIND emitente WHERE emitente.cod-emitente  =  tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
        &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' 
            &THEN  ASSIGN  SUBSTR(emitente.char-1,11,1) = "1" .
                   FIND CURRENT emitente NO-LOCK.
                   
            &ELSE  FIND dist-emitente WHERE dist-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
                   ASSIGN  dist-emitente.parceiro-b2b = YES .
                   FIND CURRENT dist-emitente NO-LOCK.
        &ENDIF

        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                             INPUT 1,
                                             INPUT "adapters/neogrid/ftp/aneft005.p").
        RUN pi-print-log(INPUT String(Emitente.cod-emitente,">>>>>>>>9") + " - " + Emitente.nome-emit). 
    END.                                     
    
    /************************fornecedores**********************************/
    IF CAN-FIND(FIRST tt-fornec) THEN
    RUN pi-print-log(INPUT CHR(10) + " * Fornecedores" ) .
    FOR EACH  tt-fornec:
        FIND emitente WHERE emitente.cod-emitente = tt-fornec.cod-emitente EXCLUSIVE-LOCK  NO-ERROR .
        &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' 
            &THEN  ASSIGN  SUBSTR(emitente.char-1,11,1) = "1" .
                   FIND CURRENT emitente NO-LOCK.
                   
            &ELSE  FIND dist-emitente WHERE dist-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
                   ASSIGN  dist-emitente.parceiro-b2b = YES .
                   FIND CURRENT dist-emitente NO-LOCK.
        &ENDIF

        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(emitente),
                                     INPUT 1,
                                     INPUT "adapters/neogrid/ccp/anecc012.p").

        RUN pi-print-log(INPUT String(Emitente.cod-emitente,">>>>>>>>9") + " - " + Emitente.nome-emit ) . 
    END.                                                                                                  
    /**************************Transporte************************************/
    IF CAN-FIND(FIRST tt-transporte) THEN
    RUN pi-print-log( INPUT CHR(10) + " * Transportadora") .
    FOR EACH  tt-transporte:
        FIND transporte WHERE transporte.cod-transp = tt-transporte.cod-transp NO-LOCK NO-ERROR.
        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(transporte),
                                             INPUT 1,
                                             INPUT "adapters/neogrid/pdp/anepd007.p").
        RUN pi-print-log (INPUT String(Transporte.cod-Transp,">>>>>>>>9") + " - " + Transporte.nome) . 
    END.
    /*************************Serie****************************************************/
    IF CAN-FIND(FIRST tt-Serie) THEN
    RUN pi-print-log( INPUT CHR(10) + " * Serie" ) .
    FOR EACH  tt-Serie:
        FIND serie WHERE Serie.serie  = tt-serie.serie NO-LOCK NO-ERROR.
        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(serie),
                                     INPUT  1,
                                     INPUT "adapters/neogrid/ftp/aneft004.p").

        RUN pi-print-log(INPUT String(Serie.Serie,"XXXXX")) . 
    END.
    /*********************Moeda************************************/
    IF CAN-FIND(FIRST tt-moeda) THEN
    RUN pi-print-log(INPUT CHR(10) + " * Moeda") .
    For each tt-moeda:
       find moeda where moeda.mo-codigo   = tt-moeda.mo-codigo NO-LOCK NO-ERROR.
       RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(moeda),
                                            INPUT 1,
                                            INPUT "adapters/neogrid/ccp/anecc011.p").
       RUN pi-print-log(INPUT STRING(moeda.mo-codigo,">>9") + " - "  + moeda.descricao).
    END.
    /********************* Item ************************************/
    IF CAN-FIND(FIRST tt-item) THEN
    RUN pi-print-log(INPUT CHR(10) + " * Item" )  .
    FOR each tt-item:
        FIND ITEM WHERE ITEM.it-codigo = tt-ITEM.it-codigo NO-LOCK NO-ERROR.
        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(ITEM),
                                     INPUT 1,
                                     INPUT "adapters/neogrid/enp/aneen005.p").
        RUN pi-print-log(String(ITEM.it-codigo,"XXXXXXXXXXXXXXXX") + " - " + ITEM.desc-item) . 
    END.
    /************************************************************************/
   /********************* Item  Fornec ************************************/
    IF CAN-FIND(FIRST tt-item-fornec) THEN
    RUN pi-print-log(INPUT CHR(10) + " * Item Fornecedor" )  .
    FOR each tt-item-fornec:
        FIND ITEM-fornec WHERE ITEM-fornec.it-codigo = tt-ITEM-fornec.it-codigo
                           AND ITEM-fornec.cod-emitente = tt-item-fornec.cod-emitente NO-LOCK NO-ERROR.
        RUN adapters/neogrid/ftp/aneft007.p (INPUT ROWID(ITEM-fornec),
                                     INPUT 1,
                                     INPUT "adapters/neogrid/ccp/anecc013.p").
        RUN pi-print-log(String(ITEM-fornec.it-codigo,"XXXXXXXXXXXXXXXX") + " - " + STRING(ITEM-fornec.cod-emitente) ) . 
    END.
    /************************************************************************/
    RUN pi-print-log(INPUT CHR(10) + "----- F I M ------" )  .        
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print-log C-Win 
PROCEDURE pi-print-log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM c-string AS CHAR.
ASSIGN c-resultado = c-resultado:SCREEN-VALUE IN FRAME f-resultado + c-string + CHR(10) . 
DISPLAY c-resultado WITH FRAME f-resultado.
ASSIGN c-resultado:CURSOR-LINE = NUM-ENTRIES(c-resultado,CHR(10)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&endif


&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN724 2.00.00.014 } /*** "010014" 27/08/2024 08:50:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN724 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN724
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName layout-import
&GLOBAL-DEFINE TableLabel Layout de Importaá∆o
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin724.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgman.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/** Definiá∆o de vari†veis locais **/
define variable c-banco        as character no-undo.
define variable c-tabela       as character no-undo.
define variable c-programa     as character no-undo.

/* Centro de Custo X Estabelecimento */   
{cdp/cd0110.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 8.67
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDefaultCS0110 DBOProgram 
PROCEDURE createDefaultCS0110 :
/*------------------------------------------------------------------------------
  Purpose:     Cria os dados padr‰es da tabela layout-import para o programa 
               CS0110 - Importaá∆o de Custos por Centro de Custos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
define variable i-cont   as integer    no-undo.
define variable i-seq    as integer    no-undo.
define variable c-bank   as character  no-undo.
define variable c-prg    as character  no-undo.
define variable c-table  as character  no-undo.

assign i-cont   = 1
       i-seq    = 1
       c-prg    = "cs0110"
       c-bank   = "mgind"
       c-table  = if l-funcao-ccusto-estab then "ext-per-custo-estab" else "ext-per-custo".

for each {&TableName} where {&TableName}.prg-importador = c-prg   and
                            {&TableName}.banco          = c-bank  and
                            {&TableName}.tabela         = c-table exclusive-lock:
    delete {&TableName}.
end.

if l-funcao-ccusto-estab then do:
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "cc-codigo"
           {&TableName}.mandatorio = yes
           {&TableName}.tamanho = 20
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 0
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "character".
           
           
           
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "cod-estabel"
           {&TableName}.mandatorio = yes
           {&TableName}.tamanho = 5
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 0
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "character".
           
           
           
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "especie"
           {&TableName}.mandatorio = yes
           {&TableName}.tamanho = 1
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 0
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "integer".
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "custo-total"
           {&TableName}.mandatorio = no
           {&TableName}.tamanho = 17
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 4
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "decimal".
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "custo-prev"
           {&TableName}.mandatorio = no
           {&TableName}.tamanho = 17
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 4
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "decimal".
	create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "custo-pad"
           {&TableName}.mandatorio = no
           {&TableName}.tamanho = 17
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 4
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "decimal".
end.
else do:
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "cc-codigo"
           {&TableName}.mandatorio = yes
           {&TableName}.tamanho = 20
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 0
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "character".
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "especie"
           {&TableName}.mandatorio = yes
           {&TableName}.tamanho = 1
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 0
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "integer".
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "custo-total"
           {&TableName}.mandatorio = no
           {&TableName}.tamanho = 17
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 4
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "decimal".
    create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "custo-prev"
           {&TableName}.mandatorio = no
           {&TableName}.tamanho = 17
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 4
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "decimal".
	create {&TableName}.
    assign {&TableName}.banco = c-bank
           {&TableName}.campo = "custo-pad"
           {&TableName}.mandatorio = no
           {&TableName}.tamanho = 17
           {&TableName}.pos-inic = i-cont
           {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
           i-cont = {&TableName}.pos-fin + 1
           {&TableName}.prg-importador = c-prg
           {&TableName}.qtd-decimais = 4
           {&TableName}.sequencia = i-seq
           i-seq = i-seq + 1
           {&TableName}.tabela = c-table
           {&TableName}.tipo = "decimal".
end.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDefaultSF0330 DBOProgram 
PROCEDURE createDefaultSF0330 :
/*------------------------------------------------------------------------------
  Purpose:     Cria os dados padr‰es da tabela layout-import para o programa 
               SF0330 - Importaá∆o Reporte Operaá‰es
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
define variable i-cont   as integer    no-undo.
define variable i-seq    as integer    no-undo.
define variable c-bank   as character  no-undo.
define variable c-prg    as character  no-undo.
define variable c-table  as character  no-undo.

assign i-cont   = 1
       i-seq    = 1
       c-prg    = "sf0330"
       c-bank   = "movmfg"
       c-table  = "rep-oper-ctrab".

for each {&TableName} where {&TableName}.prg-importador = c-prg   and
                            {&TableName}.banco          = c-bank  and
                            {&TableName}.tabela         = c-table exclusive-lock:
    delete {&TableName}.
end.

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "tipo-rep"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 2
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "nr-ord-produ"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 9
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".

/*  Campos utilizados somente pela API, n∆o necess†rios para o Layout Importaá∆o   */


/* create {&TableName}.                                                            */
/* assign {&TableName}.banco = c-bank                                              */
/*        {&TableName}.campo = "num-operac-sfc"                                    */
/*        {&TableName}.mandatorio = NO                                             */
/*        {&TableName}.tamanho = 4                                                 */
/*        {&TableName}.pos-inic = i-cont                                           */
/*        {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1  */
/*        i-cont = {&TableName}.pos-fin + 1                                        */
/*        {&TableName}.prg-importador = c-prg                                      */
/*        {&TableName}.qtd-decimais = 0                                            */
/*        {&TableName}.sequencia = i-seq                                           */
/*        i-seq = i-seq + 1                                                        */
/*        {&TableName}.tabela = c-table                                            */
/*        {&TableName}.tipo = "integer".                                           */
/* create {&TableName}.                                                            */
/* assign {&TableName}.banco = c-bank                                              */
/*        {&TableName}.campo = "num-split-operac"                                  */
/*        {&TableName}.mandatorio = NO                                             */
/*        {&TableName}.tamanho = 3                                                 */
/*        {&TableName}.pos-inic = i-cont                                           */
/*        {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1  */
/*        i-cont = {&TableName}.pos-fin + 1                                        */
/*        {&TableName}.prg-importador = c-prg                                      */
/*        {&TableName}.qtd-decimais = 0                                            */
/*        {&TableName}.sequencia = i-seq                                           */
/*        i-seq = i-seq + 1                                                        */
/*        {&TableName}.tabela = c-table                                            */
/*        {&TableName}.tipo = "integer".                                           */

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-roteiro"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 16
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "op-codigo"
       {&TableName}.mandatorio = YES
       {&TableName}.tamanho = 5
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "it-codigo"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 16
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-ctrab"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 16
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-refer"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 8
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "lote-serie"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 40
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-valid-lote"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "per-ppm"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 12
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 4
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "decimal".

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "qtd-produzida"
       {&TableName}.mandatorio = YES
       {&TableName}.tamanho = 13
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 4
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "decimal".

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "qtd-refugada"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 13
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 4
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "decimal".
       
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "qtd-refugada-un-ref"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 13
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 4
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "decimal".       

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "qtd-retrabalho"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 13
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 4
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "decimal".

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "ct-refugo"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 20
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "sc-refugo"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 20
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-motiv-refugo"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 8
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-inic-rep"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "hr-inic-rep"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 6
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-fim-rep"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "hr-fim-rep"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 6
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-inic-setup"
       {&TableName}.mandatorio = NO
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "hr-inic-setup"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 6
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-fim-setup"
       {&TableName}.mandatorio = NO
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "hr-fim-setup"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 6
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-equipe"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 8
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-operador"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 9
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-ferramenta"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 16
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "finaliza"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 1
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "logical".
create {&TableName}.                                                           
assign {&TableName}.banco = c-bank                                             
       {&TableName}.campo = "item-pai"                                         
       {&TableName}.mandatorio = NO                                           
       {&TableName}.tamanho = 16                                                
       {&TableName}.pos-inic = i-cont                                          
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1 
       i-cont = {&TableName}.pos-fin + 1                                       
       {&TableName}.prg-importador = c-prg                                     
       {&TableName}.qtd-decimais = 0                                           
       {&TableName}.sequencia = i-seq                                          
       i-seq = i-seq + 1                                                       
       {&TableName}.tabela = c-table                                           
       {&TableName}.tipo = "character".   

       
RETURN "OK":U.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDefaultSF0331 DBOProgram 
PROCEDURE createDefaultSF0331 :
/*------------------------------------------------------------------------------
  Purpose:     Cria os dados padr‰es da tabela layout-import para o programa
               SF0331 - Importaá∆o Reporte Parada.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
define variable i-cont   as integer    no-undo.
define variable i-seq    as integer    no-undo.
define variable c-bank   as character  no-undo.
define variable c-prg    as character  no-undo.
define variable c-table  as character  no-undo.

assign i-cont   = 1
       i-seq    = 1
       c-prg    = "sf0331"
       c-bank   = "movmfg"
       c-table  = "rep-parada-ctrab".

for each {&TableName} where {&TableName}.prg-importador = c-prg   and
                            {&TableName}.banco          = c-bank  and
                            {&TableName}.tabela         = c-table exclusive-lock:
    delete {&TableName}.
end.

create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "tipo-rep"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 2
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-ctrab"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 16
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-parada"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 8
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "num-om-progda"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 11
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-inic-parada"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "hr-inic-parada"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 6
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "decimal".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-fim-parada"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".       
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "hr-fim-parada"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 6
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "decimal".       
/* create {&TableName}.                                                           */
/* assign {&TableName}.banco = c-bank                                             */
/*        {&TableName}.campo = "val-refer-inic-parada"                            */
/*        {&TableName}.mandatorio = no                                            */
/*        {&TableName}.tamanho = 14                                               */
/*        {&TableName}.pos-inic = i-cont                                          */
/*        {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1 */
/*        i-cont = {&TableName}.pos-fin + 1                                       */
/*        {&TableName}.prg-importador = c-prg                                     */
/*        {&TableName}.qtd-decimais = 5                                           */
/*        {&TableName}.sequencia = i-seq                                          */
/*        i-seq = i-seq + 1                                                       */
/*        {&TableName}.tabela = c-table                                           */
/*        {&TableName}.tipo = "decimal".                                          */
/* create {&TableName}.                                                           */
/* assign {&TableName}.banco = c-bank                                             */
/*        {&TableName}.campo = "val-refer-fim-parada"                             */
/*        {&TableName}.mandatorio = no                                            */
/*        {&TableName}.tamanho = 14                                               */
/*        {&TableName}.pos-inic = i-cont                                          */
/*        {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1 */
/*        i-cont = {&TableName}.pos-fin + 1                                       */
/*        {&TableName}.prg-importador = c-prg                                     */
/*        {&TableName}.qtd-decimais = 5                                           */
/*        {&TableName}.sequencia = i-seq                                          */
/*        i-seq = i-seq + 1                                                       */
/*        {&TableName}.tabela = c-table                                           */
/*        {&TableName}.tipo = "decimal".                                          */
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-equipe"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 8
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".       
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-operador"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 9
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".       
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDefaultSF0332 DBOProgram 
PROCEDURE createDefaultSF0332 :
/*------------------------------------------------------------------------------
  Purpose:    Cria os dados padr‰es da tabela layout-import para o programa
              SF0332 - Importaá∆o Reporte Parada. 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

define variable i-cont   as integer    no-undo.
define variable i-seq    as integer    no-undo.
define variable c-bank   as character  no-undo.
define variable c-prg    as character  no-undo.
define variable c-table  as character  no-undo.

assign i-cont   = 1
       i-seq    = 1
       c-prg    = "sf0332"
       c-bank   = "movmfg"
       c-table  = "rep-ic-ctrab".

for each {&TableName} where {&TableName}.prg-importador = c-prg    and
                            {&TableName}.banco          = c-bank  and
                            {&TableName}.tabela         = c-table exclusive-lock:
    delete {&TableName}.
end.
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "tipo-rep"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 2
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "integer".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-ctrab"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 16
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "cod-ic"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 5
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "dat-rep-ic"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 10
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "date".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "hra-rep-ic"
       {&TableName}.mandatorio = no
       {&TableName}.tamanho = 6
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".
create {&TableName}.
assign {&TableName}.banco = c-bank
       {&TableName}.campo = "des-result"
       {&TableName}.mandatorio = yes
       {&TableName}.tamanho = 16
       {&TableName}.pos-inic = i-cont
       {&TableName}.pos-fin = {&TableName}.pos-inic + {&TableName}.tamanho - 1
       i-cont = {&TableName}.pos-fin + 1
       {&TableName}.prg-importador = c-prg
       {&TableName}.qtd-decimais = 0
       {&TableName}.sequencia = i-seq
       i-seq = i-seq + 1
       {&TableName}.tabela = c-table
       {&TableName}.tipo = "character".

/** Observaá∆o: Campo val-refer-ic est† sendo referenciado somente na 
    API sfapi011, que verifica data e hora do reporte e preenche seu
    valor **/
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLayout DBOProgram 
PROCEDURE createLayout :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza a tabela de acordo com os dados recebidos da temp table 
  Parameters: tt-layout-import
  Notes:       
------------------------------------------------------------------------------*/
define input parameter table for RowObject.
define input parameter p-programa as character no-undo.
define input parameter p-banco    as character no-undo.
define input parameter p-tabela   as character no-undo.

    for each {&TableName} where {&TableName}.prg-importador = p-programa and
                                {&TableName}.banco          = p-banco    and
                                {&TableName}.tabela         = p-tabela   exclusive-lock:
        delete {&TableName}.
    end.
    for each RowObject exclusive-lock:
        create {&TableName}.
        buffer-copy RowObject to {&TableName} no-error.
    end.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPosicao DBOProgram 
PROCEDURE findPosicao :
/*------------------------------------------------------------------------------
  Purpose:     Procura a posiá∆o inicial original para o registro.
  Parameters:  Input  = Sequencia
               Output = Posiá∆o Inicial
  Notes:       
------------------------------------------------------------------------------*/
define input  parameter p-programa  as character no-undo.
define input  parameter p-banco     as character no-undo.
define input  parameter p-tabela    as character no-undo.
define input  parameter p-sequencia as integer   no-undo.
define output parameter p-posicao   as integer   no-undo.

for first {&TableName} fields (pos-inic sequencia banco tabela prg-importador tamanho) where
          {&TableName}.prg-importador = p-programa   and
          {&TableName}.banco          = p-banco      and
          {&TableName}.tabela         = p-tabela     and
          {&TableName}.sequencia      = p-sequencia  no-lock:
    assign p-posicao = {&TableName}.pos-inic.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "banco":U THEN ASSIGN pFieldValue = RowObject.banco.
        WHEN "campo":U THEN ASSIGN pFieldValue = RowObject.campo.
        WHEN "prg-importador":U THEN ASSIGN pFieldValue = RowObject.prg-importador.
        WHEN "tabela":U THEN ASSIGN pFieldValue = RowObject.tabela.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "pos-fin":U THEN ASSIGN pFieldValue = RowObject.pos-fin.
        WHEN "pos-inic":U THEN ASSIGN pFieldValue = RowObject.pos-inic.
        WHEN "qtd-decimais":U THEN ASSIGN pFieldValue = RowObject.qtd-decimais.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tamanho":U THEN ASSIGN pFieldValue = RowObject.tamanho.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice id-layout
  Parameters:  
               retorna valor do campo prg-importador
               retorna valor do campo banco
               retorna valor do campo tabela
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pprg-importador LIKE layout-import.prg-importador NO-UNDO.
    DEFINE OUTPUT PARAMETER pbanco LIKE layout-import.banco NO-UNDO.
    DEFINE OUTPUT PARAMETER ptabela LIKE layout-import.tabela NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE layout-import.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pprg-importador = RowObject.prg-importador
           pbanco = RowObject.banco
           ptabela = RowObject.tabela
           psequencia = RowObject.sequencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "mandatorio":U THEN ASSIGN pFieldValue = RowObject.mandatorio.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice id-layout
  Parameters:  
               recebe valor do campo prg-importador
               recebe valor do campo banco
               recebe valor do campo tabela
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pprg-importador LIKE layout-import.prg-importador NO-UNDO.
    DEFINE INPUT PARAMETER pbanco          LIKE layout-import.banco NO-UNDO.
    DEFINE INPUT PARAMETER ptabela         LIKE layout-import.tabela NO-UNDO.
    DEFINE INPUT PARAMETER psequencia      LIKE layout-import.sequencia NO-UNDO.

    FIND FIRST bflayout-import WHERE 
        bflayout-import.prg-importador = pprg-importador AND 
        bflayout-import.banco = pbanco AND 
        bflayout-import.tabela = ptabela AND 
        bflayout-import.sequencia = psequencia exclusive-lock NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bflayout-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bflayout-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
open query {&QueryName} for each {&TableName} no-lock.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPrograma DBOProgram 
PROCEDURE openQueryPrograma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
open query {&QueryName} for each {&TableName} where 
                                 {&TableName}.prg-importador = c-programa and
                                 {&TableName}.banco          = c-banco    and 
                                 {&TableName}.tabela         = c-tabela   no-lock.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPrograma DBOProgram 
PROCEDURE setConstraintPrograma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-banco    - Banco de dados
               p-tabela   - Nome da tabela
               p-programa - Programa que chama a bo.
  Notes:       
------------------------------------------------------------------------------*/
define input parameter p-banco         as character no-undo.
define input parameter p-tabela        as character no-undo.
define input parameter p-programa      as character no-undo.

assign c-banco        = p-banco
       c-tabela       = p-tabela
       c-programa     = p-programa.
       
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaTamanho DBOProgram 
PROCEDURE ValidaTamanho :
/*------------------------------------------------------------------------------
  Purpose:     Informa o tamanho m†ximo que o campo pode ter
  Parameters:  pProgram = Nome do programa
               pSequencia = Sequencia do campo
               pTamanho = Tamanho do campo
  Notes:       Esta procedure est† ligada a criaá∆o dos layouts, qualquer modificaá∆o
               deve ser feita na procedure do programa e nesta se necess†rio.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pProgram   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pSequencia AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pTamanho   AS INTEGER   NO-UNDO.

CASE pProgram:
    /** Importaá∆o Custos Hor†rios **/
    WHEN 'CS0110':U THEN DO:
        if l-funcao-ccusto-estab then do:    
            CASE pSequencia:
                WHEN 1 THEN /** Centro Custo **/
                    ASSIGN pTamanho = 20.
                WHEN 2 THEN /** Estabelecimento **/
                    ASSIGN pTamanho = 5.
                WHEN 3 THEN /** EspÇcie **/
                    ASSIGN pTamanho = 1.
                WHEN 4 THEN /** Custo Total **/
                    ASSIGN pTamanho = 17.
                WHEN 5 THEN /** Custo Previsto **/
                    ASSIGN pTamanho = 17.
				WHEN 6 THEN /** Custo Previsto2 **/
                    ASSIGN pTamanho = 17.
            END CASE.
        END.
        ELSE DO:
            CASE pSequencia:
                WHEN 1 THEN /** Centro Custo **/
                    ASSIGN pTamanho = 20.
                WHEN 2 THEN /** EspÇcie **/
                    ASSIGN pTamanho = 1.
                WHEN 3 THEN /** Custo Total **/
                    ASSIGN pTamanho = 17.
                WHEN 4 THEN /** Custo Previsto **/
                    ASSIGN pTamanho = 17.
				WHEN 5 THEN /** Custo Previsto2 **/
                    ASSIGN pTamanho = 17.
            END CASE.
        END.
    END.
    /** Importaá∆o Reporte Operaá∆o **/
    WHEN 'SF0330':U THEN
        CASE pSequencia:
            WHEN 1 THEN /** Tipo Reporte **/
                ASSIGN pTamanho = 2.
            WHEN 2 THEN /** Nr. Ordem Produá∆o **/
                ASSIGN pTamanho = 9.
            WHEN 3 THEN /** Roteiro **/
                ASSIGN pTamanho = 16.
            WHEN 4 THEN /** Operaá∆o **/
                ASSIGN pTamanho = 5.
            WHEN 5 THEN /** Item **/
                ASSIGN pTamanho = 16.
            WHEN 6 THEN /** Centro Trabalho **/
                ASSIGN pTamanho = 16.
            WHEN 7 THEN /** Referància **/
                ASSIGN pTamanho = 8.
            WHEN 8 THEN /** Lote **/
                ASSIGN pTamanho = 40.
            WHEN 9 THEN /** Data lote **/
                ASSIGN pTamanho = 10.
            WHEN 10 THEN /*** per-ppm ***/
                ASSIGN pTamanho = 12.
            WHEN 11 THEN /** Quantidade Produzida **/
                ASSIGN pTamanho = 13.
            WHEN 12 THEN /** Quantidade Refugada **/
                ASSIGN pTamanho = 13.
            WHEN 13 THEN /** Quantidade Refugada Unidade do REfugo**/
                ASSIGN pTamanho = 13.                
            WHEN 14 THEN  /*** Quantidade Retrabalho    ***/
                ASSIGN pTamanho = 13.
            WHEN 15 THEN /*** Conta Refugo  ***/
                ASSIGN pTamanho = 20.
            WHEN 16 THEN /*** Sub-Conta Refugo  ***/
                ASSIGN pTamanho = 20.
            WHEN 17 THEN /*** motivo refugo ***/
                ASSIGN pTamanho = 8.
            WHEN 18 THEN /** Data In°cio Reporte **/
                ASSIGN pTamanho = 10.
            WHEN 19 THEN /** Hora In°cio Reporte **/
                ASSIGN pTamanho = 6.
            WHEN 20 THEN /** Data TÇrmino Reporte **/
                ASSIGN pTamanho = 10.
            WHEN 21 THEN /** Hora TÇrmino Reporte **/
                ASSIGN pTamanho = 6.
            WHEN 22 THEN /** Data In°cio Setup **/
                ASSIGN pTamanho = 10.
            WHEN 23 THEN /** Hora In°cio Setup **/
                ASSIGN pTamanho = 6.
            WHEN 24 THEN /** Data TÇrmino Setup **/
                ASSIGN pTamanho = 10.
            WHEN 25 THEN /** Hora TÇrmino Setup **/
                ASSIGN pTamanho = 6.
            WHEN 26 THEN /** Equipe **/
                ASSIGN pTamanho = 8.
            WHEN 27 THEN /** Operador **/
                ASSIGN pTamanho = 9.
            WHEN 28 THEN /** Ferramenta **/
                ASSIGN pTamanho = 16.
            WHEN 29 THEN /** Finalizar? **/
                ASSIGN pTamanho = 1.
            WHEN 30 THEN
                ASSIGN pTamanho = 16.
        END CASE.
    /** Importaá∆o Parada **/
    WHEN 'SF0331':U THEN
        CASE pSequencia:
            WHEN 1 THEN /** Tipo Reporte **/
                ASSIGN pTamanho = 2.
            WHEN 2 THEN /** Centro Trabalho **/
                ASSIGN pTamanho = 16.
            WHEN 3 THEN /** Parada **/
                ASSIGN pTamanho = 8.
            WHEN 4 THEN /** Nr. Parada Programada **/
                ASSIGN pTamanho = 11.
            WHEN 5 THEN /** Data In°cio Parada **/
                ASSIGN pTamanho = 10.
            WHEN 6 THEN /** Hora In°cio Parada **/
                ASSIGN pTamanho = 6.
            WHEN 7 THEN /** Data In°cio Parada **/
                ASSIGN pTamanho = 10.
            WHEN 8 THEN /** Hora In°cio Parada **/
                ASSIGN pTamanho = 6.
            WHEN 9 THEN /** Equipe **/
                ASSIGN pTamanho = 8.
            WHEN 10 THEN /** Operador **/
                ASSIGN pTamanho = 9.
        END CASE.
    /** Importaá∆o Item Controle **/
    WHEN 'SF0332':U THEN
        CASE pSequencia:
            WHEN 1 THEN /** Tipo Reporte **/
                ASSIGN pTamanho = 2.
            WHEN 2 THEN /** Centro Trabalho **/
                ASSIGN pTamanho = 16.
            WHEN 3 THEN /** Item Controle **/
                ASSIGN pTamanho = 5.
            WHEN 4 THEN /** Data reporte **/
                ASSIGN pTamanho = 10.
            WHEN 5 THEN /** Hora Reporte **/
                ASSIGN pTamanho = 6.
            WHEN 6 THEN /** Resultado **/
                ASSIGN pTamanho = 16.
        END CASE.
END CASE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


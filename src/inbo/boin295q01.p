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
{include/i-prgvrs.i BOIN295Q01 2.00.00.010} /*** "010010" 23/11/2023 16:19:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin295q01 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName pedido-compr
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName pedido-compr
&GLOBAL-DEFINE TableLabel Pedidos de Compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin295.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    &SCOPED-DEFINE ind-rep INDEXED-REPOSITION
&ELSE
    &SCOPED-DEFINE ind-rep    
&ENDIF 
 

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
  
  {inbo/boin295.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
/** {method/dboqry.i} **/
DEFINE QUERY {&QueryName} for {&TableName}, ordem-compra, emitente scrolling.

/******************************ATENCAO*************************************
-  Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
- Include com pre-processadores que diferenciam releases 
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{cdp/cdcfgdis.i}  /* Defini‡Æo dos pr‚-processadores que diferenciam releases*/

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-num-pedido-ini  as int  no-undo.
def var i-num-pedido-fim  as int  no-undo.
def var c-estabel-ini     as char no-undo.
def var c-estabel-fim     as char no-undo.
def var l-nao-emitido     as log  no-undo.
def var l-emitido         as log  no-undo.
def var l-eliminado       as log  no-undo.
def var l-pendente        as log  no-undo.
DEF VAR i-cod-emitente    AS INT  NO-UNDO.
def var i-emitente-ini    as int  no-undo.
def var i-emitente-fim    as int  no-undo.
def var c-nome-abrev-ini  as char no-undo.
def var c-nome-abrev-fim  as char no-undo.

/* Include com pr‚-processadores que diferenciam releases */
{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.5
         WIDTH              = 40.57.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cargo-ass[02]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[02].
        WHEN "cargo-ass[03]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[03].
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "desc-forma":U THEN ASSIGN pFieldValue = RowObject.desc-forma.
        WHEN "desc-via":U THEN ASSIGN pFieldValue = RowObject.desc-via.
        WHEN "end-cobranca":U THEN ASSIGN pFieldValue = RowObject.end-cobranca.
        WHEN "compl-entrega":U THEN ASSIGN pFieldValue = RowObject.compl-entrega.
        WHEN "mot-elimina":U THEN ASSIGN pFieldValue = RowObject.mot-elimina.
        WHEN "nome-ass[01]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[01].
        WHEN "nome-ass[02]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[02].
        WHEN "nome-ass[03]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[03].
        &if defined(bf_mat_contratos) &then
        &else WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato. &endif      
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.
        WHEN "end-entrega":U THEN ASSIGN pFieldValue = RowObject.end-entrega.
        WHEN "c-cod-tabela":U THEN ASSIGN pFieldValue = RowObject.c-cod-tabela.
        WHEN "c-descr-merc[01]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[01].
        WHEN "c-descr-merc[02]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[02].
        WHEN "c-descr-merc[03]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[03].
        WHEN "c-embalagem[01]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[01].
        WHEN "c-embalagem[02]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[02].
        WHEN "c-embalagem[03]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[03].
        WHEN "c-observacao[01]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[01].
        WHEN "c-observacao[02]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[02].
        WHEN "c-observacao[03]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[03].
        WHEN "c-observacao[04]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[04].
        WHEN "c-observacao[05]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[05].
        WHEN "c-prazo":U THEN ASSIGN pFieldValue = RowObject.c-prazo.
        WHEN "cargo-ass[01]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[01].
        &if defined(bf-mat-comex) &then            
            WHEN "comentarios[1]":U THEN ASSIGN pFieldValue = RowObject.comentarios[1].        
            WHEN "comentarios[2]":U THEN ASSIGN pFieldValue = RowObject.comentarios[2].
            WHEN "comentarios[3]":U THEN ASSIGN pFieldValue = RowObject.comentarios[3].
            WHEN "comentarios[4]":U THEN ASSIGN pFieldValue = RowObject.comentarios[4].
            WHEN "comentarios[5]":U THEN ASSIGN pFieldValue = RowObject.comentarios[5].
            WHEN "comentarios[6]":U THEN ASSIGN pFieldValue = RowObject.comentarios[6].
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.        
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.                    
        &else 
            WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.        
            WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
            WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.            
        &endif
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.        
        &endif        
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "de-vl-frete-i":U THEN ASSIGN pFieldValue = RowObject.de-vl-frete-i.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "de-vl-fob":U THEN ASSIGN pFieldValue = RowObject.de-vl-fob.
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        &endif        
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        &if defined(bf_mat_contratos) &then
          when "nr-contrato" then ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-prox-ped":U THEN ASSIGN pFieldValue = RowObject.nr-prox-ped.        
        WHEN "num-ped-benef":U THEN ASSIGN pFieldValue = RowObject.num-ped-benef.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "via-transp":U THEN ASSIGN pFieldValue = RowObject.via-transp.
        WHEN "i-cod-forma":U THEN ASSIGN pFieldValue = RowObject.i-cod-forma.
        WHEN "i-cod-porto":U THEN ASSIGN pFieldValue = RowObject.i-cod-porto.
        WHEN "i-cod-via":U THEN ASSIGN pFieldValue = RowObject.i-cod-via.
        WHEN "i-exportador":U THEN ASSIGN pFieldValue = RowObject.i-exportador.
        WHEN "i-importador":U THEN ASSIGN pFieldValue = RowObject.i-importador.
        WHEN "i-moeda":U THEN ASSIGN pFieldValue = RowObject.i-moeda.
        WHEN "i-situacao":U THEN ASSIGN pFieldValue = RowObject.i-situacao.
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "cod-maq-origem":U THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.        
            WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.            
            WHEN "l-classificacao":U THEN ASSIGN pFieldValue = RowObject.l-classificacao.
            WHEN "l-tipo-ped":U THEN ASSIGN pFieldValue = RowObject.l-tipo-ped.
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.            
            WHEN "nro-proc-alteracao":U THEN ASSIGN pFieldValue = RowObject.nro-proc-alteracao.
            WHEN "nro-proc-entrada":U THEN ASSIGN pFieldValue = RowObject.nro-proc-entrada.
            WHEN "nro-proc-saida":U THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
            WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.            
            WHEN "num-processo-mp":U THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.            
            WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.            
            WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
            WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.            
        &endif        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice NUMERO
  Parameters:
               retorna valor dos campos do ­ndice NUMERO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then            
    &else
        DEFINE OUTPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

        /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.

        ASSIGN pnum-pedido = RowObject.num-pedido.

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "emergencial":U THEN ASSIGN pFieldValue = RowObject.emergencial.
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
        WHEN "l-ind-prof":U THEN ASSIGN pFieldValue = RowObject.l-ind-prof.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "impr-pedido":U THEN ASSIGN pFieldValue = RowObject.impr-pedido.
        &if defined(bf-mat-comex) &then            
            WHEN "l-classificacao":U THEN ASSIGN pFieldValue = RowObject.l-classificacao.        
            WHEN "l-tipo-ped":U THEN ASSIGN pFieldValue = RowObject.l-tipo-ped.        
            WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.                
        &else
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.        
        &endif        
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then            
    &else
        DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
        DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

        /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
            RETURN "NOK":U.

        CASE pFieldName:
            OTHERWISE RETURN "NOK":U.
        END CASE.

        RETURN "OK":U.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice NUMERO
  Parameters:
               recebe valor dos campos do ­ndice NUMERO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    FIND FIRST bfpedido-compr WHERE
        bfpedido-compr.num-pedido = pnum-pedido
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpedido-compr THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-compr)).
    IF RETURN-VALUE = "NOK":U THEN 
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedEmitNomeByEmitente DBOProgram 
PROCEDURE openQueryPedEmitNomeByEmitente :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       openquery4
------------------------------------------------------------------------------*/

&if defined(bf-mat-comex) &then            
&else     
       /* Pedidos Fornecedores Estrangeiros ou Trading - por c¢digo do emitente */
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                        {&TableName}.cod-emitente >= i-emitente-ini       AND
                                        {&TableName}.cod-emitente <= i-emitente-fim       AND
                                        {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                        {&TableName}.num-pedido   <= i-num-pedido-fim NO-LOCK
                                        USE-INDEX emitente,
                                   FIRST ordem-compra NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND 
                                         emitente.nome-abrev  >= c-nome-abrev-ini          AND 
                                         emitente.nome-abrev  <= c-nome-abrev-fim          AND
                                         emitente.natureza    > 2                          AND 
                                         emitente.natureza    < 5           NO-LOCK {&ind-rep}.
&endif  

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedEmitNomeByNomeAbrev DBOProgram 
PROCEDURE openQueryPedEmitNomeByNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       openquery5
------------------------------------------------------------------------------*/

&if defined(bf-mat-comex) &then
       /* Pedidos Fornecedores Estrangeiros ou Trading - por nome abreviado */
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido   <= i-num-pedido-fim     AND
                                         {&TableName}.cod-emitente >= i-emitente-ini       AND
                                         {&TableName}.cod-emitente <= i-emitente-fim       NO-LOCK,
                                   FIRST ordem-compra where 
                                         ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND 
                                         emitente.nome-abrev  >= c-nome-abrev-ini           AND 
                                         emitente.nome-abrev  <= c-nome-abrev-fim           AND
                                         (emitente.natureza = "E" or emitente.natureza = "T" ) NO-LOCK                                                   
                                         by emitente.nome-abrev.
&else     
       /* Pedidos Fornecedores Estrangeiros ou Trading - por nome abreviado */
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido   <= i-num-pedido-fim     AND
                                         {&TableName}.cod-emitente >= i-emitente-ini       AND
                                         {&TableName}.cod-emitente <= i-emitente-fim       NO-LOCK,
                                   FIRST ordem-compra NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND
                                         emitente.nome-abrev  >= c-nome-abrev-ini           AND
                                         emitente.nome-abrev  <= c-nome-abrev-fim           AND
                                         (emitente.natureza = 3 or emitente.natureza = 4 )  NO-LOCK
                                         by emitente.nome-abrev {&ind-rep}.
&endif  

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedEmitNomeByPedido DBOProgram 
PROCEDURE openQueryPedEmitNomeByPedido :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       openquery3
------------------------------------------------------------------------------*/

&if defined(bf-mat-comex) &then            
       /* Pedidos Fornecedores Estrangeiros ou Trading - por nœmero do pedido */
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido   <= i-num-pedido-fim     AND
                                         {&TableName}.cod-emitente >= i-emitente-ini       AND
                                         {&TableName}.cod-emitente <= i-emitente-fim       NO-LOCK,
                                   FIRST ordem-compra where 
                                         ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND 
                                         emitente.nome-abrev  >= c-nome-abrev-ini           AND 
                                         emitente.nome-abrev  <= c-nome-abrev-fim           AND
                                         (emitente.natureza = "E" or emitente.natureza = "T")   NO-LOCK                                                   
                                         by {&TableName}.num-pedido.                                              
&else     
       /* Pedidos Fornecedores Estrangeiros ou Trading - por n£mero do pedido */
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido   <= i-num-pedido-fim     AND
                                         {&TableName}.cod-emitente >= i-emitente-ini       AND
                                         {&TableName}.cod-emitente <= i-emitente-fim       NO-LOCK
                                         USE-INDEX numero,
                                   FIRST ordem-compra where 
                                         ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND 
                                         emitente.nome-abrev  >= c-nome-abrev-ini           AND 
                                         emitente.nome-abrev  <= c-nome-abrev-fim           AND
                                         (emitente.natureza = 3 or emitente.natureza = 4)   NO-LOCK {&ind-rep}.

&endif  

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedSituacaoByNomeAbrev DBOProgram 
PROCEDURE openQueryPedSituacaoByNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       openquery2
------------------------------------------------------------------------------*/

&if defined(bf-mat-comex) &then            
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido   <= i-num-pedido-fim     AND
                                         {&TableName}.cod-emitente >= i-emitente-ini       AND
                                         {&TableName}.cod-emitente <= i-emitente-fim       NO-LOCK,
                                   FIRST ordem-compra where 
                                         ordem-compra.num-pedido = {&TableName}.num-pedido AND
                                        (({&TableName}.situacao  = "N" and l-emitido)          OR 
                                         ({&TableName}.situacao  = "C" and l-nao-emitido)      OR 
                                         ({&TableName}.situacao  = "T" and l-eliminado)        OR
                                         (ordem-compra.situacao  = "C" and l-pendente))        NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND 
                                         emitente.nome-abrev  >= c-nome-abrev-ini           AND 
                                         emitente.nome-abrev  <= c-nome-abrev-fim           NO-LOCK                                                   
                                         by emitente.nome-abrev {&ind-rep}. 
&else
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.cod-emitente >= i-emitente-ini       AND
                                         {&TableName}.cod-emitente <= i-emitente-fim       AND
                                         {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido   <= i-num-pedido-fim     AND
                                         {&TableName}.end-entrega  >= c-estabel-ini        AND
                                         {&TableName}.end-entrega  <= c-estabel-fim    NO-LOCK,
                                   FIRST ordem-compra WHERE  
                                         ordem-compra.num-pedido = {&TableName}.num-pedido AND
                                        (({&TableName}.situacao = 1 and l-emitido)          OR 
                                         ({&TableName}.situacao = 2 and l-nao-emitido)      OR 
                                         ({&TableName}.situacao = 3 and l-eliminado)        OR
                                         (ordem-compra.situacao = 2 and l-pendente))        NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND 
                                         emitente.nome-abrev  >= c-nome-abrev-ini           AND 
                                         emitente.nome-abrev  <= c-nome-abrev-fim           NO-LOCK                                                   
                                         BY emitente.nome-abrev 
                                         BY {&TableName}.cod-emitente {&ind-rep}. 
&endif  

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedSituacaoByPedido DBOProgram 
PROCEDURE openQueryPedSituacaoByPedido :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       openquery1
------------------------------------------------------------------------------*/

&if defined(bf-mat-comex) &then            
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido   <= i-num-pedido-fim     AND
                                         {&TableName}.cod-emitente >= i-emitente-ini       AND
                                         {&TableName}.cod-emitente <= i-emitente-fim       NO-LOCK,
                                   FIRST ordem-compra where 
                                         ordem-compra.num-pedido = {&TableName}.num-pedido AND
                                           (({&TableName}.situacao = "N" and l-emitido)          OR 
                                            ({&TableName}.situacao = "C" and l-nao-emitido)      OR 
                                            ({&TableName}.situacao = "T" and l-eliminado)        OR
                                        (ordem-compra.situacao  = "C" and l-pendente))        NO-LOCK,
                                   first emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente AND 
                                         emitente.nome-abrev  >= c-nome-abrev-ini           AND 
                                         emitente.nome-abrev  <= c-nome-abrev-fim           NO-LOCK                                                   
                                         by {&TableName}.num-pedido {&ind-rep}. 
&else     
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                         {&TableName}.num-pedido >= i-num-pedido-ini     AND
                                         {&TableName}.num-pedido <= i-num-pedido-fim     NO-LOCK,
                                   FIRST ordem-compra where 
                                         ordem-compra.num-pedido = {&TableName}.num-pedido AND
                                        (({&TableName}.situacao = 1 and l-emitido)      OR 
                                         ({&TableName}.situacao = 2 and l-nao-emitido)  OR 
                                         ({&TableName}.situacao = 3 and l-eliminado)    OR
                                         (ordem-compra.situacao = 2 and l-pendente))       NO-LOCK,
                                   first emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente NO-LOCK 
                                   BY {&tableName}.num-pedido
                                   {&ind-rep}. 
&endif  

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedSituacaoByEmitente DBOProgram 
PROCEDURE openQueryPedSituacaoByEmitente :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       openquery1
------------------------------------------------------------------------------*/

&if defined(bf-mat-comex) &then            

&else     
       open query {&QueryName} FOR EACH {&TableName} WHERE
                                        {&tableName}.cod-emitente  = i-cod-emitente       AND
                                        {&TableName}.num-pedido   >= i-num-pedido-ini     AND
                                        {&TableName}.num-pedido   <= i-num-pedido-fim     AND 
                                        {&tableName}.end-entrega  >= c-estabel-ini        and
                                        {&tableName}.end-entrega  <= c-estabel-fim NO-LOCK,
                                   FIRST ordem-compra WHERE 
                                         ordem-compra.num-pedido = {&TableName}.num-pedido AND
                                        (({&TableName}.situacao = 1 and l-emitido)      OR 
                                         ({&TableName}.situacao = 2 and l-nao-emitido)  OR 
                                         ({&TableName}.situacao = 3 and l-eliminado)    OR
                                         (ordem-compra.situacao = 2 and l-pendente))       NO-LOCK,
                                   FIRST emitente WHERE 
                                         emitente.cod-emitente = {&TableName}.cod-emitente NO-LOCK 
                                   BY {&tableName}.cod-emitente
                                   BY {&tableName}.num-pedido
                                   {&ind-rep}. 
&endif  

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedSituacaoByEstabel DBOProgram 
PROCEDURE openQueryPedSituacaoByEstabel :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       openquery1
------------------------------------------------------------------------------*/

       open query {&QueryName} FOR EACH {&TableName} WHERE
                                        {&tableName}.end-entrega >= c-estabel-ini        AND
                                        {&tableName}.end-entrega <= c-estabel-fim        AND
                                        {&TableName}.num-pedido  >= i-num-pedido-ini     AND
                                        {&TableName}.num-pedido  <= i-num-pedido-fim     NO-LOCK,
                                  FIRST ordem-compra WHERE 
                                        ordem-compra.num-pedido = {&TableName}.num-pedido AND
                                       (({&TableName}.situacao = 1 and l-emitido)      OR 
                                        ({&TableName}.situacao = 2 and l-nao-emitido)  OR 
                                        ({&TableName}.situacao = 3 and l-eliminado)    OR
                                        (ordem-compra.situacao = 2 and l-pendente))       NO-LOCK,
                                  FIRST emitente WHERE 
                                        emitente.cod-emitente = {&TableName}.cod-emitente NO-LOCK 
                                  BY {&tableName}.end-entrega
                                  BY {&tableName}.num-pedido
                                  {&ind-rep} . 

        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnNomeAbrevEmitente DBOProgram 
PROCEDURE returnNomeAbrevEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then  
    &else
        define input parameter  p-rowid as rowid no-undo.
        define output parameter c-valor as char no-undo.

        find first bfpedido-compr where rowid(bfpedido-compr) = p-rowid no-lock no-error.
        if avail bfpedido-compr then
            find emitente where emitente.cod-emitente = bfpedido-compr.cod-emitente no-lock no-error.
        if avail emitente then
            assign c-valor = emitente.nome-abrev.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedEmitNome DBOProgram 
PROCEDURE setConstraintPedEmitNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       antiga setConstraint2
------------------------------------------------------------------------------*/

/* 
**
** Utilizado para openQueries 3,4,5 do zoom WZ06IN295 e Z10IN295 (Importa‡Æo)
**
*/
    def input param p-num-pedido-ini   as int  no-undo.
    def input param p-num-pedido-fim   as int  no-undo.
    def input param p-cod-emitente-ini as int  no-undo.
    def input param p-cod-emitente-fim as int  no-undo.
    def input param p-nome-abrev-ini   as char no-undo.
    def input param p-nome-abrev-fim   as char no-undo. 

    assign i-num-pedido-ini  = p-num-pedido-ini
           i-num-pedido-fim  = p-num-pedido-fim
           i-emitente-ini    = p-cod-emitente-ini
           i-emitente-fim    = p-cod-emitente-fim 
           c-nome-abrev-ini  = p-nome-abrev-ini 
           c-nome-abrev-fim  = p-nome-abrev-fim. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedSituacao DBOProgram 
PROCEDURE setConstraintPedSituacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       antiga setConstraint1
------------------------------------------------------------------------------*/

    def input param p-num-pedido-ini  as int  no-undo.
    def input param p-num-pedido-fim  as int  no-undo.
    def input param p-emitente-ini    as int  no-undo.
    def input param p-emitente-fim    as int  no-undo.
    def input param p-nome-abrev-ini  as char no-undo.
    def input param p-nome-abrev-fim  as char no-undo.    
    def input param p-estabel-ini     as char no-undo. 
    def input param p-estabel-fim     as char no-undo.  
    def input param p-nao-emitido     as log  no-undo.
    def input param p-emitido         as log  no-undo.
    def input param p-eliminado       as log  no-undo.
    def input param p-pendente        as log  no-undo.

        assign i-num-pedido-ini  = p-num-pedido-ini
               i-num-pedido-fim  = p-num-pedido-fim
               i-emitente-ini    = p-emitente-ini
               i-emitente-fim    = p-emitente-fim 
               c-nome-abrev-ini  = p-nome-abrev-ini 
               c-nome-abrev-fim  = p-nome-abrev-fim               
               c-estabel-ini     = p-estabel-ini 
               c-estabel-fim     = p-estabel-fim
               l-emitido         = p-emitido
               l-nao-emitido     = p-nao-emitido
               l-eliminado       = p-eliminado
               l-pendente        = p-pendente.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedSituacaoByPedido DBOProgram 
PROCEDURE setConstraintPedSituacaoByPedido :
    def input param p-num-pedido-ini  as int  no-undo.
    def input param p-num-pedido-fim  as int  no-undo.
    def input param p-nao-emitido     as log  no-undo.
    def input param p-emitido         as log  no-undo.
    def input param p-eliminado       as log  no-undo.
    def input param p-pendente        as log  no-undo.

        assign i-num-pedido-ini  = p-num-pedido-ini
               i-num-pedido-fim  = p-num-pedido-fim
               l-emitido         = p-emitido
               l-nao-emitido     = p-nao-emitido
               l-eliminado       = p-eliminado
               l-pendente        = p-pendente.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedSituacaoByEmitente DBOProgram 
PROCEDURE setConstraintPedSituacaoByEmitente :
    DEF INPUT PARAM p-cod-emitente    AS INT  NO-UNDO.
    def input param p-num-pedido-ini  as int  no-undo.
    def input param p-num-pedido-fim  as int  no-undo.
    DEF INPUT PARAM p-estabel-ini     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-estabel-fim     AS CHAR NO-UNDO.
    def input param p-nao-emitido     as log  no-undo.
    def input param p-emitido         as log  no-undo.
    def input param p-eliminado       as log  no-undo.
    def input param p-pendente        as log  no-undo.

        assign i-cod-emitente    = p-cod-emitente
               i-num-pedido-ini  = p-num-pedido-ini
               i-num-pedido-fim  = p-num-pedido-fim
               c-estabel-ini     = p-estabel-ini
               c-estabel-fim     = p-estabel-fim
               l-emitido         = p-emitido
               l-nao-emitido     = p-nao-emitido
               l-eliminado       = p-eliminado
               l-pendente        = p-pendente.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedSituacaoByEstabel DBOProgram 
PROCEDURE setConstraintPedSituacaoByEstabel :

    DEF INPUT PARAM p-cod-estabel-ini AS CHAR NO-UNDO.
    DEF INPUT PARAM p-cod-estabel-fim AS CHAR NO-UNDO.
    def input param p-num-pedido-ini  as int  no-undo.
    def input param p-num-pedido-fim  as int  no-undo.
    def input param p-nao-emitido     as log  no-undo.
    def input param p-emitido         as log  no-undo.
    def input param p-eliminado       as log  no-undo.
    def input param p-pendente        as log  no-undo.

        assign c-estabel-ini    = p-cod-estabel-ini
               c-estabel-fim    = p-cod-estabel-fim
               i-num-pedido-ini = p-num-pedido-ini
               i-num-pedido-fim = p-num-pedido-fim
               l-emitido        = p-emitido
               l-nao-emitido    = p-nao-emitido
               l-eliminado      = p-eliminado
               l-pendente       = p-pendente.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then            
    &else

        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

        /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
              executadas ---*/
        /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as valida»„es ---*/

        find first rowObject no-lock no-error.

        /*--- Verifica ocorr¼ncia de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

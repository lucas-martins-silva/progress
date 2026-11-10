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
********************************************************************************/
{include/i-prgvrs.i BOIN274Q04 2.00.00.011 } /*** "010011" 23/11/2023 16:19:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274q04 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName tt-digita-ordem
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-digita-ordem
&GLOBAL-DEFINE TableLabel tt-digita-ordem
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/

/********* Temp-tables referentes … Gera‡Æo de Processos **********/
{inbo/boin274q04.i tt-digita-ordem}
{inbo/boin274q04.i RowObject}

define temp-table tt-param
    field destino      as integer
    field arquivo      as char
    field usuario      as char
    field data-exec    as date
    field hora-exec    as integer
    field classifica   as integer
    field d-dt-inicio  as date
    field c-fam-ini    as char
    field c-fam-fim    as char
    field i-ord-ini    as integer
    field i-ord-fim    as integer
    field d-dt-ini     as date
    field d-dt-fim     as date
    field d-dte-ini    as date
    field d-dte-fim    as date
    field c-comp-ini   as char format "x(12)"
    field c-comp-fim   as char format "x(12)"
    field c-classe     as char
    field c-destino    as char
    field c-estab-gestor like estabelec.cod-estabel
    field c-descricao    like proc-compra.descricao
    field quebra       as logical init yes.     
    
def temp-table tt-row-ordem NO-UNDO
    field r-ordem as rowid
    field r-rowid as rowid.
    
/*****************************************************************/        

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*---------- Include de Pr‚-Processadores -------------*/
{cdp/cdcfgmat.i}


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
         HEIGHT             = 18
         WIDTH              = 66.2.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "comprador":U THEN ASSIGN pFieldValue = RowObject.comprador.
        WHEN "item":U      THEN ASSIGN pFieldValue = RowObject.item.
        WHEN "familia":U   THEN ASSIGN pFieldValue = RowObject.familia.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "emissao":U THEN ASSIGN pFieldValue = RowObject.emissao.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ordem":U     THEN ASSIGN pFieldValue = RowObject.ordem.
        WHEN "emitente":U  THEN ASSIGN pFieldValue = RowObject.emitente.
        WHEN "processo":U  THEN ASSIGN pFieldValue = RowObject.processo.
        WHEN "situacao":U  THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice COMPRADOR
  Parameters:
               retorna valor dos campos do ¡ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-comprado = RowObject.comprador.
    ASSIGN pnumero-ordem = RowObject.ordem.

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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice COMPRADOR
  Parameters:
               recebe valor dos campos do ¡ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FIND FIRST bftt-digita-ordem WHERE
        bftt-digita-ordem.comprador = pcod-comprado AND
        bftt-digita-ordem.ordem = pnumero-ordem
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-digita-ordem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-digita-ordem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH tt-digita-ordem NO-LOCK 
    by  tt-digita-ordem.ordem INDEXED-REPOSITION .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraGeracaoProcessos DBOProgram 
PROCEDURE carregaTTOrdemCompraGeracaoProcessos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input  param table for tt-param .
    
    def var d-dt         as date no-undo.
    def var d-dt-entrega as date no-undo.
    
    FIND FIRST param-global no-lock no-error.
    FIND FIRST param-compra no-lock no-error.
    FIND FIRST tt-param     NO-LOCK NO-ERROR.

    if avail tt-param then do:
        for each ordem-compra no-lock
            where ordem-compra.cod-emitente  = 0 
            and   ordem-compra.numero-ordem >= tt-param.i-ord-ini
            and   ordem-compra.numero-ordem <= tt-param.i-ord-fim
            and   ordem-compra.cod-comprado >= tt-param.c-comp-ini
            and   ordem-compra.cod-comprado <= tt-param.c-comp-fim
            and   ordem-compra.nr-processo   = 0:
                            
            if  ordem-compra.situacao <> 5
            and ordem-compra.situacao <> 1 then next.
            
            if  param-global.modulo-mp and
                not param-compra.compra-centr and
                ordem-compra.int-1 = 1 then next.
            
            /* evita acesso duplicado a tabela */
            if  not avail item 
            or (avail item and item.it-codigo <> ordem-compra.it-codigo ) then
            find item where 
                 item.it-codigo = ordem-compra.it-codigo no-lock no-error.
                 
            if not avail item then next.
            if item.fm-codigo < tt-param.c-fam-ini
            or item.fm-codigo > tt-param.c-fam-fim then next.
        
            /* Procura a data da primeira entrega */
            for first prazo-compra
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock: end.
            if  avail prazo-compra then
                assign d-dt-entrega = prazo-compra.data-entrega.
            if  tt-param.classifica = 1 then
                assign d-dt = ordem-compra.data-emissao.
            else
                assign d-dt = d-dt-entrega
                            - item.res-for-comp
                            - item.res-cq-comp
                            - item.res-int-comp.
        
            if  d-dt >= tt-param.d-dt-ini
            and d-dt <= tt-param.d-dt-fim
            and d-dt-entrega >= tt-param.d-dte-ini
            and d-dt-entrega <= tt-param.d-dte-fim then do:
                create tt-digita-ordem.
                assign tt-digita-ordem.ordem     = ordem-compra.numero-ordem
                       tt-digita-ordem.item      = ordem-compra.it-codigo
                       tt-digita-ordem.comprador = ordem-compra.cod-comprado
                       tt-digita-ordem.emissao   = ordem-compra.data-emissao
                       tt-digita-ordem.emitente  = ordem-compra.cod-emitente
                       tt-digita-ordem.processo  = ordem-compra.nr-processo
                       tt-digita-ordem.situacao  = ordem-compra.situacao 
                       tt-digita-ordem.familia   = item.fm-codigo
                       tt-digita-ordem.r-rowid   = rowid(ordem-compra).
            end.
        end.
    end.    
    OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraGeracaoProcessos2 DBOProgram 
PROCEDURE carregaTTOrdemCompraGeracaoProcessos2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM TABLE FOR tt-row-ordem.
    
    FOR EACH tt-row-ordem:
        FIND FIRST ordem-compra 
             WHERE ROWID(ordem-compra) = tt-row-ordem.r-ordem NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
            CREATE tt-digita-ordem.
            
            FIND item WHERE
                 item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL item THEN
                ASSIGN tt-digita-ordem.familia = item.fm-codigo.

            ASSIGN tt-digita-ordem.ordem     = ordem-compra.numero-ordem
                   tt-digita-ordem.item      = ordem-compra.it-codigo
                   tt-digita-ordem.comprador = ordem-compra.cod-comprado
                   tt-digita-ordem.emissao   = ordem-compra.data-emissao
                   tt-digita-ordem.emitente  = ordem-compra.cod-emitente
                   tt-digita-ordem.processo  = ordem-compra.nr-processo
                   tt-digita-ordem.situacao  = ordem-compra.situacao
                   tt-digita-ordem.r-rowid   = rowid(ordem-compra).
        END.    
    END.    
    OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaMultiplantaGeracaoProcessos DBOProgram 
PROCEDURE verificaMultiplantaGeracaoProcessos :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o m¢dulo de multiplanta est  implantado, se estiver o
           c¢digo do estabelecimento ficar  dispon¡vel para altera‡äes na 
           gera‡Æo de processos de ordens de compra.
                
  Parameters:  ipar1 : lHabilitaEstabel : indica se o campo estabelecimento 
                                          ficar  dispon¡vel.
  Notes:
------------------------------------------------------------------------------*/
    def output param lHabilitaEstabel as log no-undo.

     &if defined(bf_mat_contratos) &then
           FIND FIRST param-global no-lock no-error.
           if param-global.modulo-mp then
              assign lHabilitaEstabel = YES.
           else 
              assign lHabilitaEstabel = NO.
      &else
           assign lHabilitaEstabel = NO.
      &endif
      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME      

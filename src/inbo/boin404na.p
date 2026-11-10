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
{include/i-prgvrs.i BOIN404NA 2.00.00.048 } /*** "010048" 17/06/2025 16:40:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin404na MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOIN404
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName saldo-terc
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}  

{utp/ut-glob.i}
{cdp/cdcfgren.i} /* pre-processor indices grendene - nao remover */
{cdp/cdcfgmat.i} /* --- its35061 --- */

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin404.i RowObject}
{inbo/boin404.i tt-saldo-terc-aux}
{cdp/cd4305.i1}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&tableName}.
DEFINE BUFFER b-item         FOR item.
DEFINE BUFFER b-componente   FOR componente.
DEFINE BUFFER b-natur-oper   FOR natur-oper.

/*--- Defini‡Æo das vari veis ---*/
def var c-estab           like estabelec.cod-estabel                           no-undo.

def var i-emitente-ini    like emitente.cod-emitente                           no-undo.
def var i-emitente-fim    like emitente.cod-emitente init 999999999            no-undo. 
def var c-item-ini        like item.it-codigo                                  no-undo.
def var c-item-fim        like item.it-codigo        init "ZZZZZZZZZZZZZZZZ":U no-undo.
def var c-serie-ini       like docum-est.serie-docto                           no-undo.
def var c-serie-fim       like docum-est.serie-docto init "ZZZZZ":U            no-undo.
def var c-nro-docto-ini   like docum-est.nro-docto                             no-undo.
def var c-nro-docto-fim   like docum-est.nro-docto   init "ZZZZZZZZZZZZZZZZ":U no-undo.
def var c-nat-oper-ini    like docum-est.nat-operacao                          no-undo.
def var c-nat-oper-fim    like docum-est.nat-operacao init "999zzz":U          no-undo.
def var d-dt-retorno-ini  like saldo-terc.dt-retorno  init &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF          no-undo.
def var d-dt-retorno-fim  like saldo-terc.dt-retorno  init 12/31/9999          no-undo.
def var i-emit            like emitente.cod-emitente                           no-undo.        

def var l-sai-benef       as logical init yes                                  no-undo.
def var l-ent-benef       as logical init yes                                  no-undo.
def var l-transf          as logical init yes                                  no-undo.
def var l-sai-consig      as logical init yes                                  no-undo.
def var l-ent-consig      as logical init yes                                  no-undo.
def var l-ent-fut         as logical init yes                                  no-undo.
def var l-preco-medio     as logical init yes                                  no-undo.
def var l-saldo-zero      as logical init yes                                  no-undo.
def var i-cod-emitente    as int                                               no-undo.
def var c-it-codigo       as char                                              no-undo.
def var l-sai-dep-fech    as logical init yes                                  no-undo.
def var l-ent-dep-fech    as logical init yes                                  no-undo.
def var l-sai-armaz-ger   as logical init yes                                  no-undo.
def var l-ent-armaz-ger   as logical init yes                                  no-undo.

define variable iCodEmit      as inte no-undo.
define variable cItCodigo     as char no-undo.
defin  variable cCallerProg   as char no-undo.
define variable cCodEstab     as char no-undo.
define variable iCodEmitIni   as inte no-undo.
define variable iCodEmitFim   as inte no-undo.
define variable cItemIni      as char no-undo.
define variable cItemFim      as char no-undo.
define variable cSerieIni     as char no-undo.
define variable cSerieFim     as char no-undo.
define variable cNroDoctoIni  as char no-undo.
define variable cNroDoctoFim  as char no-undo.
define variable cNat-OperIni   as char no-undo.
define variable cNat-OperFim   as char no-undo.
define variable dDtRetornoIni as date no-undo.
define variable dDtRetornoFim as date no-undo.
DEFINE VARIABLE lRemEntFutura AS LOG  NO-UNDO.

/********************* saldo-terc-duplic ********************************/
DEFINE TEMP-TABLE tt-saldo-terc-duplic NO-UNDO
    FIELD cod-emitente   like saldo-terc.cod-emitente
    FIELD cod-estabel    like saldo-terc.cod-estabel
    FIELD tipo-sal-terc  like saldo-terc.tipo-sal-terc
    FIELD it-codigo      like saldo-terc.it-codigo.
/**************************************************************/

def var iEmitente         as int                  no-undo.
def var cNroDocto         as char                 no-undo.
def var cSerieDocto       as char                 no-undo.
def var cNatOperacao      as char                 no-undo.
def var cDocIni           as char                 no-undo.
def var cDocFim           as char                 no-undo.
def var cNatOperIni       as char                 no-undo.
def var cNatOperFim       as char                 no-undo.
def var iTipoSaldTerc     as int                  no-undo.
def var i-tipo-sal-terc   as int                  no-undo.
def var cCodEstabel       as char                 no-undo.
def var cTipNav           as char                 no-undo.
def var lUltimo           as logi                 no-undo initial no.

define var lSaiBenef  as logi no-undo.
define var lEntBenef  as logi no-undo.
define var lTransf    as logi no-undo.
define var lSaiConsig as logi no-undo.
define var lEntConsig as logi no-undo.

def var c-estab-ini   as char no-undo.
def var c-estab-fim   as char no-undo.
DEF VAR c-cod-estabel-usuar AS CHAR NO-UNDO.

/********************* EMBALAGEM ********************************/
define temp-table tt-saldo-terc no-undo
   field cod-emitente like saldo-terc.cod-emitente
   field nro-docto    like saldo-terc.nro-docto
   field serie-docto  like saldo-terc.serie-docto
   field cod-estabel  like saldo-terc.cod-estabel
   field quantidade   like saldo-terc.quantidade.  
/**************************************************************/
{cdp/cdcfgdis.i}

{cdp/cd9700.i} /* define variaveis para cd9700.i1 */

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 1.96
         WIDTH              = 38.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetNext DBOProgram 
PROCEDURE afterGetNext :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    if lUltimo = yes then
        return "NOK":U.
    else
        return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCopyBuffer2TT DBOProgram 
PROCEDURE beforeCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def var lSaldo as logical initial no.
    assign lUltimo = no.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeGetNext DBOProgram 
PROCEDURE beforeGetNext :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def var lSaldo as logical initial no.

    assign cTipNav = "next":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeGetPrev DBOProgram 
PROCEDURE beforeGetPrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    assign cTipNav = "prev":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateTotalTerceiros DBOProgram 
PROCEDURE calculateTotalTerceiros :
/*------------------------------------------------------------------------------
  Notes: Efetua o calculo dos valores e quantidades do saldo-terc conforme
         os registro criados  pela  procedure getBatchRecordsCustom.
------------------------------------------------------------------------------*/

    def var de-preco-unit as dec no-undo.

    if  l-preco-medio then 
        assign de-preco-unit = {&tableName}.valor-mat-m[1] +
                               {&tableName}.valor-mob-m[1] + {&tableName}.valor-ggf-m[1].
    else
        for first componente fields ( preco-total[1] quantidade ) 
            of {&tableName} no-lock:
            assign de-preco-unit = componente.preco-total[1] / componente.quantidade.
        end.

    assign RowObjectAux.char-2     = (if {&tableName}.tipo-sal-terc > 0 and 
                                        {&tableName}.tipo-sal-terc < 6  then 
                                            {ininc/i01in404.i 04 {&tableName}.tipo-sal-terc}
                                     else "")
           RowObjectAux.quantidade = RowObjectAux.quantidade + {&tableName}.quantidade
           RowObjectAux.dec-1      = RowObjectAux.dec-1      + {&tableName}.dec-1
           RowObjectAux.valor[1]   = RowObjectAux.valor[1]   + ( {&tableName}.quantidade * de-preco-unit ).

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNaturOper DBOProgram 
PROCEDURE findNaturOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNatOperacao   like docum-est.nat-operacao no-undo.

    if  not avail natur-oper
    or  natur-oper.nat-operacao <> piNatOperacao then 

        for first natur-oper
            fields (  nat-operacao denominacao 
                      tp-oper-terc char-2 ind-entfut)
            where natur-oper.nat-operacao = piNatOperacao no-lock.
        end.

    if  not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgind natur-oper 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAllByDocumento DBOProgram 
PROCEDURE getAllByDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM c-nro-docto    LIKE saldo-terc.nro-docto    NO-UNDO.
DEF INPUT PARAM c-serie-docto  LIKE saldo-terc.serie-docto  NO-UNDO.
DEF INPUT PARAM c-nat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-it-docto.
DEF OUTPUT PARAM TABLE FOR tt-saldo-terc-aux.

DEF VAR d-quantidade LIKE saldo-terc.quantidade NO-UNDO.

EMPTY TEMP-TABLE tt-saldo-terc-aux.

FOR EACH bf{&TableName} NO-LOCK
    WHERE bf{&TableName}.nro-docto    = c-nro-docto 
    AND   bf{&TableName}.serie-docto  = c-serie-docto 
    AND   bf{&TableName}.nat-operacao = c-nat-operacao 
    AND   bf{&TableName}.cod-emitente = i-cod-emitente 
    AND   bf{&TableName}.quantidade > 0:
    ASSIGN d-quantidade = 0.
    FOR EACH componente OF bf{&TableName} NO-LOCK,
        EACH tt-it-docto NO-LOCK
        WHERE tt-it-docto.serie-comp = componente.serie-docto
        AND   tt-it-docto.nro-comp   = componente.nro-docto
        AND   tt-it-docto.nat-comp   = componente.nat-operacao 
        AND   tt-it-docto.seq-comp   = componente.sequencia:
        ASSIGN d-quantidade = d-quantidade + tt-it-docto.quantidade[1].
    END.

    IF d-quantidade <> bf{&TableName}.quantidade  THEN DO:

        CREATE tt-saldo-terc-aux.
        BUFFER-COPY bf{&TableName} EXCEPT bf{&TableName}.quantidade TO tt-saldo-terc-aux.
        ASSIGN tt-saldo-terc-aux.r-rowid = ROWID(bf{&TableName})
               tt-saldo-terc-aux.quantidade  = bf{&TableName}.quantidade - d-quantidade.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram 
PROCEDURE getBatchRecordsCustom :
/*------------------------------------------------------------------------------
  Notes: Mesma fun‡Æo da getBatchRecords, por‚m com algumas customiza‡äes na 
         cria‡Æo da temp-table.
         Este m‚todo ‚ executada nos programas re0706 e re0707 que devem ter
         seus dados customizados no browse.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.   

    DEFINE VAR iLastEmitenteCreated       AS INT     NO-UNDO.

    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.

    /*--- reposiciona o registro no rowid recebido como parƒmetro ---*/
    if  pRowid <> ? then do:
        reposition {&queryName} to rowid pRowid no-error.
        if  error-status:error then
            return "NOK":U.

        get Next {&queryName} no-lock.    

        if  not avail {&tableName} then
            return "NOK":U.    
    end.

    /*--- posiciona no pr¢ximo/an
    terior registro conforme parƒmetro recebido ---*/
    if  pNext then do:
        get Next {&queryName} no-lock.
        if  not avail {&tableName} then
            return "NOK":U.
    end.

    assign pRowsReturned = 0.

    /*--- cria a temp-table auxiliar baseado na query ---*/
    do while avail {&tableName}:

        IF  pRowsToReturn <> 0 
        AND pRowsReturned >= pRowsToReturn 
        AND {&tableName}.cod-emitente <> iLastEmitenteCreated 
        THEN LEAVE.

        find first rowObjectAux 
            where  rowObjectAux.it-codigo     = {&tablename}.it-codigo
              and  rowObjectAux.cod-estabel   = {&tableName}.cod-estabel
              and  rowObjectAux.cod-emitente  = {&tableName}.cod-emitente
              and  rowObjectAux.tipo-sal-terc = {&tableName}.tipo-sal-terc 
              &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                       AND  rowObjectAux.emite-comp    = {&tableName}.emite-comp
                   AND  rowObjectAux.log-entreg-fut = {&tableName}.log-entreg-fut
                  &ENDIF
              NO-ERROR.

        if  not avail rowObjectAux then do:
            CREATE RowObjectAux.
            BUFFER-COPY {&tableName} except quantidade dec-1 valor TO RowObjectAux.
            assign pRowsReturned        = pRowsReturned + 1
                   iLastEmitenteCreated = {&tableName}.cod-emitente.           
        end.

        run CalculateTotalTerceiros.        

        get next {&queryName} no-lock. 

    end.

    if  not avail {&tableName} then
        get last {&queryName} no-lock.

    if  not avail {&tableName} then
        return "NOK":U.

    find last rowObjectAux no-error.
    if  avail rowObjectAux then
        assign rowObjectAux.r-rowid = rowid({&tableName}).

    return "OK":U.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desp-cons":U THEN ASSIGN pFieldValue = RowObject.desp-cons.
        WHEN "qt-aloca-trans":U THEN ASSIGN pFieldValue = RowObject.qt-aloca-trans.
        WHEN "qtd-ini":U THEN ASSIGN pFieldValue = RowObject.qtd-ini.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "sald-ini-mat":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat.
        WHEN "sald-ini-mob":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob.
        WHEN "valor[1]":U THEN ASSIGN pFieldValue = RowObject.valor[1].
        WHEN "valor[2]":U THEN ASSIGN pFieldValue = RowObject.valor[2].
        WHEN "valor[3]":U THEN ASSIGN pFieldValue = RowObject.valor[3].
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-icm[1]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[1].
        WHEN "valor-icm[2]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[2].
        WHEN "valor-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[1].
        WHEN "valor-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[2].
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[1].
        WHEN "valor-mob[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[2].
        WHEN "valor-mob[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "vl-icm-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-icm-cmi.
        WHEN "vl-ipi-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-cmi.
        WHEN "vl-saldo-mat":U THEN ASSIGN pFieldValue = RowObject.vl-saldo-mat.
        WHEN "vl-saldo-mob":U THEN ASSIGN pFieldValue = RowObject.vl-saldo-mob.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescItem DBOProgram 
PROCEDURE getDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piDescItem     as char format "x(60)" no-undo.

    if  avail RowObject then do:

        for first b-item 
            fields ( tipo-contr desc-item )
            where b-item.it-codigo = RowObject.it-codigo no-lock :
        end.        

        if  b-item.tipo-contr = 4 then do:  /* D‚bito Direto */

            for first b-componente 
                fields ( b-componente.narrativa ) 
                of  RowObject no-lock:
            end.

            if  avail b-componente then 
                assign piDescItem = b-componente.narrativa.

        end. 
        else 
            assign piDescItem = b-item.desc-item.
    end.

    RETURN "OK":U.            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescTipoSaldo DBOProgram 
PROCEDURE getDescTipoSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: recebe o tipo do saldo terceiros e retorna sua descri‡Æo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param i-tipo-sal as  int no-undo.
    def output param c-tipo-sal as char no-undo.

    if i-tipo-sal <= 0 
    or i-tipo-sal > 10 then 
       return "NOK":U.

    assign c-tipo-sal = {ininc/i01in404.i 04 i-tipo-sal}.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmitenteNomeAbrevCGC DBOProgram 
PROCEDURE getEmitenteNomeAbrevCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna o Nome abreviado e o CGC do emitente.
------------------------------------------------------------------------------*/

    def input  param i-cod-emitente as int  no-undo.
    def output param c-nome-abrev   as char no-undo.
    def output param c-cgc          as char no-undo.

    for first emitente fields ( nome-abrev cgc ) use-index codigo
        where emitente.cod-emitente = i-cod-emitente no-lock:
        assign c-nome-abrev = emitente.nome-abrev
               c-cgc        = emitente.cgc.
    end.

    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmitenteNomeEmit DBOProgram 
PROCEDURE getEmitenteNomeEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna o Nome do Emitente.
------------------------------------------------------------------------------*/

    def input  param i-cod-emitente as int  no-undo.
    def output param c-nome-emit    as char no-undo.

    for first emitente fields ( nome-emit ) use-index codigo
        where emitente.cod-emitente = i-cod-emitente no-lock:
        assign c-nome-emit = emitente.nome-emit.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEstabParamEstoq DBOProgram 
PROCEDURE getEstabParamEstoq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param c-cod-estabel as char no-undo.

    for first param-estoq fields ( estabel-pad ) no-lock:
        ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

        /* Fun‡Æo Super/Minas */
        &IF DEFINED(Bf_dis_usuario_estab) &THEN
            IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                                 AND funcao.ativo     = YES) THEN DO:
               RUN cdp/cd8702.p (input c-seg-usuario,
                                      INPUT-OUTPUT c-cod-estabel-usuar).
            END.
        &ENDIF
        assign c-cod-estabel = c-cod-estabel-usuar.
    end.

    assign c-estab = c-cod-estabel.

    if  not avail param-estoq then
        return "NOK":U.

    return "OK":U.  

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-prod":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo-sal-terc":U THEN ASSIGN pFieldValue = RowObject.tipo-sal-terc.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemDescItem DBOProgram 
PROCEDURE getItemDescItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes: Retorna a descri‡Æo do Item
------------------------------------------------------------------------------*/
    
    def input  param c-serie-docto   as char no-undo.
    def input  param c-nro-docto     as char no-undo. 
    def input  param i-cod-emitente  as INT  no-undo. 
    def input  param c-nat-operacao  as char no-undo. 
    def input  param c-item-cod      as char no-undo.
    def input  param c-cod-refer     as char no-undo.
    def input  param i-sequencia     as int  no-undo.
    def output param c-desc          as char no-undo.
    
    for first item fields ( it-codigo desc-item tipo-contr narrativa )
        where item.it-codigo = c-item-cod no-lock:
    
        if item.tipo-contr = 4 and item.it-codigo <> " " then 
            for first item-mat fields (log-1)
                where item-mat.it-codigo = c-item-cod no-lock:
            end.

        if item.it-codigo = "" or
            (avail item-mat and item-mat.log-1) then 
                for first b-componente fields ( b-componente.narrativa )
                    where b-componente.serie-docto  = c-serie-docto    and
                          b-componente.nro-docto    = c-nro-docto      and
                          b-componente.cod-emitente = i-cod-emitente   and
                          b-componente.nat-operacao = c-nat-operacao   and
                          b-componente.it-codigo    = c-item-cod       and
                          b-componente.cod-refer    = c-cod-refer      and
                          b-componente.sequencia    = i-sequencia      no-lock: 
                            
                    assign c-desc = substr(b-componente.narrativa,1,60).
                end. /*End do 'for first b-componente'*/
        else
            assign c-desc = item.desc-item.
    end. /*End do 'for first item fields'*/

    if  not avail item then
        return "OK":U.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemUn DBOProgram 
PROCEDURE getItemUn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna a Unidade de Medida do Item
------------------------------------------------------------------------------*/

    def input  param c-item-cod  as char no-undo.
    def output param c-un        as char no-undo.

    for first item fields ( un ) use-index codigo 
        where item.it-codigo = c-item-cod no-lock:
        assign c-un   = item.un.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE saldo-terc.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE saldo-terc.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE saldo-terc.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE saldo-terc.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE saldo-terc.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        /* --- its35061 --- */
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN 
        WHEN "log-entreg-fut" THEN pFieldValue = RowObject.log-entreg-fut.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNarrativa DBOProgram 
PROCEDURE getNarrativa :
/*------------------------------------------------------------------------------
  Purpose:    busca narrativa do item do saldo em poder de terceiros   
  Parameters: r-saldo-terc -  Rowid da tabela saldo-terc
              c-narrativa  -  Retorna narrativa do item
  Notes:      M‚todo utilizado no programa ft4012 - botÆo Exibe Narrativa  
------------------------------------------------------------------------------*/

    def input  param r-saldo-terc as rowid no-undo.
    def output param c-narrativa  as char  no-undo.

    for first saldo-terc fields (cod-emitente cod-refer it-codigo nat-operacao
                                 nro-docto serie-docto sequencia) where
         rowid(saldo-terc) = r-saldo-terc no-lock: 

         for first componente fields (narrativa) where 

                      componente.serie-docto  = saldo-terc.serie-docto
                  and componente.nro-docto    = saldo-terc.nro-docto
                  and componente.cod-emitente = saldo-terc.cod-emitente
                  and componente.nat-operacao = saldo-terc.nat-operacao
                  and componente.it-codigo    = saldo-terc.it-codigo
                  and componente.cod-refer    = saldo-terc.cod-refer
                  and componente.sequencia    = saldo-terc.sequencia     no-lock: end.
    end.

    assign c-narrativa = if avail componente then componente.narrativa
                         else "".

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNaturOperDenominacao DBOProgram 
PROCEDURE getNaturOperDenominacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piNatOperacao  like natur-oper.nat-operacao  no-undo.
    def output param piDenominacao  as char                       no-undo.

    run findNaturOper ( piNatOperacao ).

    assign piDenominacao = if  avail natur-oper 
                           then natur-oper.denominacao
                           else " ".

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPrecoUnitInformado DBOProgram 
PROCEDURE getPrecoUnitInformado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piPrecoUnit    like item-doc-est.preco-unit[1] no-undo.

    if  not avail RowObject then 
        RETURN "NOK":U.

    for first componente 
        fields ( preco-total quantidade )
        of RowObject no-lock:
    end.
    if  avail componente then 
        assign piPrecoUnit = componente.preco-total[1] / componente.quantidade.

    return "OK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToDocumento DBOProgram 
PROCEDURE goToDocumento :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto  LIKE saldo-terc.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto    LIKE saldo-terc.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.

    FIND FIRST saldo-terc 
         WHERE saldo-terc.serie-docto  = pserie-docto 
           AND saldo-terc.nro-docto    = pnro-docto 
           AND saldo-terc.cod-emitente = pcod-emitente 
           AND saldo-terc.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAILABLE saldo-terc THEN 
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE saldo-terc.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE saldo-terc.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE saldo-terc.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE saldo-terc.sequencia NO-UNDO.

    FIND FIRST bfsaldo-terc WHERE 
        bfsaldo-terc.serie-docto = pserie-docto AND 
        bfsaldo-terc.nro-docto = pnro-docto AND 
        bfsaldo-terc.cod-emitente = pcod-emitente AND 
        bfsaldo-terc.nat-operacao = pnat-operacao AND 
        bfsaldo-terc.it-codigo = pit-codigo AND 
        bfsaldo-terc.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsaldo-terc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsaldo-terc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToEmitente DBOProgram 
PROCEDURE linkToEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pHandle as handle no-undo.

    run getKey in pHandle(output i-cod-emitente).

    run setConstraintOfEmitente in this-procedure (input i-cod-emitente).

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem DBOProgram 
PROCEDURE linkToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pHandle as handle no-undo.

    run getKey in pHandle(output c-it-codigo).

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyDocumento DBOProgram 
PROCEDURE openQuerybyDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   open query {&QUERYNAME} for each {&TableName} 
                             where {&TableName}.cod-estabel   = cCodEstabel 
                               and {&TableName}.cod-emitente  = iEmitente
                               and {&TableName}.quantidade    > 0
                               and {&TableName}.nro-docto     >= cDocIni
                               and {&TableName}.nro-docto     <= cDocFim
                               and {&TableName}.nat-operacao  >= cNatOperIni
                               and {&TableName}.nat-operacao  <= cNatOperFim
                               and {&tablename}.it-codigo     >= cItemIni
                               and {&tablename}.it-codigo     <= cItemFim
                               and {&TableName}.tipo-sal-terc  = itiposaldterc NO-LOCK 
                               By {&TableName}.nro-docto
                                By {&TableName}.serie-docto                               
                                 By {&tablename}.it-codigo indexed-reposition.

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyItem DBOProgram 
PROCEDURE openQuerybyItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   open query {&QUERYNAME} for each {&TableName} 
                             where {&TableName}.cod-estabel   = cCodEstabel 
                               and {&TableName}.cod-emitente  = iEmitente
                               and {&TableName}.quantidade    > 0
                               and {&TableName}.nro-docto     >= cDocIni
                               and {&TableName}.nro-docto     <= cDocFim
                               and {&TableName}.nat-operacao  >= cNatOperIni
                               and {&TableName}.nat-operacao  <= cNatOperFim
                               and {&tablename}.it-codigo     >= cItemIni
                               and {&tablename}.it-codigo     <= cItemFim
                               and {&TableName}.tipo-sal-terc  = itiposaldterc NO-LOCK 
                               By {&tablename}.it-codigo
                                By {&TableName}.serie-docto                               
                                 By {&TableName}.nro-docto indexed-reposition.


  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCustomOfEmitente DBOProgram 
PROCEDURE openQueryCustomOfEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.cod-estabel  = c-estab
           and {&tablename}.it-codigo   >= c-item-ini
           and {&tablename}.it-codigo   <= c-item-fim
           and {&tableName}.serie-docto  >= c-serie-ini
           and {&tableName}.serie-docto  <= c-serie-fim
           and {&tableName}.nro-docto    >= c-nro-docto-ini
           and {&tableName}.nro-docto    <= c-nro-docto-fim
           and {&tableName}.nat-operacao >= c-nat-oper-ini
           and {&tableName}.nat-operacao <= c-nat-oper-fim
           and {&tableName}.dt-retorno   >= d-dt-retorno-ini
           and {&tableName}.dt-retorno   <= d-dt-retorno-fim           
           and {&tableName}.quantidade   > 0 
           and (   ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
                or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
                or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
                or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
                or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ) )
                no-lock
                by {&tableName}.cod-emitente                
                by {&tablename}.it-codigo
                by {&tableName}.cod-estabel
                by {&tableName}.serie-docto
                by {&tableName}.nro-docto
                by {&tableName}.nat-operacao
                by {&tableName}.cod-refer
                by {&tableName}.sequencia
                indexed-reposition.

     return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCustomOfEmitenteFutureDelivery DBOProgram 
PROCEDURE openQueryCustomOfEmitenteFutureDelivery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
         where {&tableName}.cod-emitente  = i-cod-emitente
           and {&tableName}.cod-estabel   = c-estab
           and {&tablename}.it-codigo    >= c-item-ini
           and {&tablename}.it-codigo    <= c-item-fim
           and {&tableName}.serie-docto  >= c-serie-ini
           and {&tableName}.serie-docto  <= c-serie-fim
           and {&tableName}.nro-docto    >= c-nro-docto-ini
           and {&tableName}.nro-docto    <= c-nro-docto-fim
           and {&tableName}.nat-operacao >= c-nat-oper-ini
           and {&tableName}.nat-operacao <= c-nat-oper-fim
           and {&tableName}.dt-retorno   >= d-dt-retorno-ini
           and {&tableName}.dt-retorno   <= d-dt-retorno-fim           
           and {&tableName}.quantidade   > 0 
           and (  (
                     ( {&tableName}.tipo-sal-terc = 1  and l-sai-benef ) 
                  or ( {&tableName}.tipo-sal-terc = 2  and l-ent-benef )
                  or ( {&tableName}.tipo-sal-terc = 3  and l-transf    ) 
                  or ( {&tableName}.tipo-sal-terc = 4  and l-sai-consig) 
                  or ( {&tableName}.tipo-sal-terc = 5  and l-ent-consig)
                  or ( {&tableName}.tipo-sal-terc = 7  and l-sai-dep-fech ) 
                  or ( {&tableName}.tipo-sal-terc = 8  and l-ent-dep-fech )
                  or ( {&tableName}.tipo-sal-terc = 9  and l-sai-armaz-ger) 
                  or ( {&tableName}.tipo-sal-terc = 10 and l-ent-armaz-ger)
                  ) AND NOT {&tableName}.log-entreg-fut
                    OR {&tableName}.log-entreg-fut AND l-ent-fut
               )
                no-lock
                by {&tableName}.cod-emitente                
                by {&tablename}.it-codigo
                by {&tableName}.cod-estabel
                by {&tableName}.serie-docto
                by {&tableName}.nro-docto
                by {&tableName}.nat-operacao
                by {&tableName}.cod-refer
                by {&tableName}.sequencia
                indexed-reposition.

     return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCustomOfItem DBOProgram 
PROCEDURE openQueryCustomOfItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
         where {&tablename}.it-codigo     = c-it-codigo
           and {&tableName}.cod-estabel   = c-estab
           and {&tableName}.cod-emitente >= i-emitente-ini
           and {&tableName}.cod-emitente <= i-emitente-fim
           and {&tableName}.serie-docto  >= c-serie-ini
           and {&tableName}.serie-docto  <= c-serie-fim
           and {&tableName}.nro-docto    >= c-nro-docto-ini
           and {&tableName}.nro-docto    <= c-nro-docto-fim
           and {&tableName}.nat-operacao >= c-nat-oper-ini
           and {&tableName}.nat-operacao <= c-nat-oper-fim
           and {&tableName}.dt-retorno   >= d-dt-retorno-ini
           and {&tableName}.dt-retorno   <= d-dt-retorno-fim
           and ( ( {&tableName}.quantidade > 0)
              or ( {&tableName}.quantidade = 0 and  l-saldo-zero) )
           and (   ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
                or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
                or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
                or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
                or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ) )
                no-lock
                by {&tablename}.it-codigo
                by {&tableName}.cod-emitente
                by {&tableName}.cod-estabel
                by {&tableName}.serie-docto
                by {&tableName}.nro-docto
                by {&tableName}.nat-operacao
                by {&tableName}.cod-refer
                by {&tableName}.sequencia
                indexed-reposition.

     return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCustomOfItemFutureDelivery DBOProgram 
PROCEDURE openQueryCustomOfItemFutureDelivery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
         where {&tablename}.it-codigo     = c-it-codigo
           and {&tableName}.cod-estabel   = c-estab
           and {&tableName}.cod-emitente >= i-emitente-ini
           and {&tableName}.cod-emitente <= i-emitente-fim
           and {&tableName}.serie-docto  >= c-serie-ini
           and {&tableName}.serie-docto  <= c-serie-fim
           and {&tableName}.nro-docto    >= c-nro-docto-ini
           and {&tableName}.nro-docto    <= c-nro-docto-fim
           and {&tableName}.nat-operacao >= c-nat-oper-ini
           and {&tableName}.nat-operacao <= c-nat-oper-fim
           and {&tableName}.dt-retorno   >= d-dt-retorno-ini
           and {&tableName}.dt-retorno   <= d-dt-retorno-fim
           and ( ( {&tableName}.quantidade > 0)
              or ( {&tableName}.quantidade = 0       and l-saldo-zero))
           and (  (
                     ( {&tableName}.tipo-sal-terc = 1  and l-sai-benef ) 
                  or ( {&tableName}.tipo-sal-terc = 2  and l-ent-benef )
                  or ( {&tableName}.tipo-sal-terc = 3  and l-transf    ) 
                  or ( {&tableName}.tipo-sal-terc = 4  and l-sai-consig) 
                  or ( {&tableName}.tipo-sal-terc = 5  and l-ent-consig)
                  or ( {&tableName}.tipo-sal-terc = 7  and l-sai-dep-fech ) 
                  or ( {&tableName}.tipo-sal-terc = 8  and l-ent-dep-fech )
                  or ( {&tableName}.tipo-sal-terc = 9  and l-sai-armaz-ger) 
                  or ( {&tableName}.tipo-sal-terc = 10 and l-ent-armaz-ger)
                  ) AND NOT {&tableName}.log-entreg-fut
                    OR {&tableName}.log-entreg-fut AND l-ent-fut
               ) 
                no-lock
                by {&tablename}.it-codigo
                by {&tableName}.cod-emitente
                by {&tableName}.cod-estabel
                by {&tableName}.serie-docto
                by {&tableName}.nro-docto
                by {&tableName}.nat-operacao
                by {&tableName}.cod-refer
                by {&tableName}.sequencia
                indexed-reposition.

     return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitente DBOProgram 
PROCEDURE openQueryEmitente :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH saldo-terc 
    where {&tableName}.cod-emitente       = iCodEmit
           and {&tableName}.cod-estabel   = cCodEstab
           and {&tablename}.it-codigo    >= cItemIni
           and {&tablename}.it-codigo    <= cItemFim
           and {&tableName}.serie-docto  >= cSerieIni      
           and {&tableName}.serie-docto  <= cSerieFim      
           and {&tableName}.nro-docto    >= cNroDoctoIni  
           and {&tableName}.nro-docto    <= cNroDoctoFim  
           and {&tableName}.nat-operacao >= cNat-OperIni   
           and {&tableName}.nat-operacao <= cNat-OperFim   
           and {&tableName}.dt-retorno   >= dDtRetornoIni 
           and {&tableName}.dt-retorno   <= dDtRetornoFim 
           and {&tableName}.quantidade   > 0 
           and (   ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
                or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
                or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
                or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
                or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ))
                no-lock
                by {&tableName}.cod-emitente
                by {&tablename}.it-codigo
                by {&tableName}.cod-estabel
                by {&tableName}.serie-docto
                by {&tableName}.nro-docto
                by {&tableName}.nat-operacao
                by {&tableName}.cod-refer
                by {&tableName}.sequencia
                INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitente1 DBOProgram 
PROCEDURE openQueryEmitente1 :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH saldo-terc 
    where {&tableName}.cod-emitente       = iCodEmit
           and {&tableName}.cod-estabel   = cCodEstab
           and {&tablename}.it-codigo    >= cItemIni
           and {&tablename}.it-codigo    <= cItemFim
           and {&tableName}.serie-docto  >= cSerieIni      
           and {&tableName}.serie-docto  <= cSerieFim      
           and {&tableName}.nro-docto    >= cNroDoctoIni  
           and {&tableName}.nro-docto    <= cNroDoctoFim  
           and {&tableName}.nat-operacao >= cNat-OperIni   
           and {&tableName}.nat-operacao <= cNat-OperFim   
           and {&tableName}.dt-retorno   >= dDtRetornoIni 
           and {&tableName}.dt-retorno   <= dDtRetornoFim 
           and {&tableName}.quantidade   > 0 
           and (   ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
                or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
                or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
                or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
                or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ))
            no-lock
            by {&tableName}.cod-emitente
            by {&tablename}.it-codigo
            INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH saldo-terc where
                                     saldo-terc.it-codigo    =  cItCodigo     and
                                     saldo-terc.cod-estabel  =  cCodEstab     and
                                     saldo-terc.cod-emitente >= iCodEmitIni   and
                                     saldo-terc.cod-emitente <= iCodEmitFim   and
                                     saldo-terc.serie-docto  >= cSerieIni     and
                                     saldo-terc.serie-docto  <= cSerieFim     and 
                                     saldo-terc.nro-docto    >= cNroDoctoIni  and
                                     saldo-terc.nro-docto    <= cNroDoctoFim  and                                 
                                     saldo-terc.nat-operacao >= cNat-OperIni  and
                                     saldo-terc.nat-operacao <= cNat-OperFim  and
                                     saldo-terc.dt-retorno   >= dDtRetornoIni and                                  
                                     saldo-terc.dt-retorno   <= dDtRetornoFim and
                                     {&tableName}.quantidade >  0 
                               and (   ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  )  
                                    or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )  
                                    or ( {&tableName}.tipo-sal-terc = 3 and l-transf     )   
                                    or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig )  
                                    or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ) )
                                     NO-LOCK 
                                  BY saldo-terc.it-codigo 
                                  BY saldo-terc.cod-emitente 
                                  BY saldo-terc.cod-estabel 
                                  BY saldo-terc.serie-docto 
                                  BY saldo-terc.nro-docto 
                                  BY saldo-terc.nat-operacao 
                                  BY saldo-terc.cod-refer 
                                  BY saldo-terc.sequencia
                                  INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem1 DBOProgram 
PROCEDURE openQueryItem1 :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH saldo-terc where
                                     saldo-terc.it-codigo    =  cItCodigo     and
                                     saldo-terc.cod-estabel  =  cCodEstab     and
                                     saldo-terc.cod-emitente >= iCodEmitIni   and
                                     saldo-terc.cod-emitente <= iCodEmitFim   and
                                     saldo-terc.serie-docto  >= cSerieIni     and
                                     saldo-terc.serie-docto  <= cSerieFim     and 
                                     saldo-terc.nro-docto    >= cNroDoctoIni  and
                                     saldo-terc.nro-docto    <= cNroDoctoFim  and                                 
                                     saldo-terc.nat-operacao >= cNat-OperIni  and
                                     saldo-terc.nat-operacao <= cNat-OperFim  and
                                     saldo-terc.dt-retorno   >= dDtRetornoIni and
                                     saldo-terc.dt-retorno   <= dDtRetornoFim and
                                     {&tableName}.quantidade >  0 
                               and (   ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  )  
                                    or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )  
                                    or ( {&tableName}.tipo-sal-terc = 3 and l-transf     )   
                                    or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig )  
                                    or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ) )
                                     NO-LOCK 
                                  BY saldo-terc.it-codigo 
                                  BY saldo-terc.cod-emitente 
                                  INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName} no-lock indexed-reposition.

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryofDocumento DBOProgram 
PROCEDURE openQueryofDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   open query {&QUERYNAME} for each {&TableName} 
                             where {&TableName}.cod-emitente  = iEmitente
                               and {&TableName}.nro-docto     = cNroDocto
                               and {&TableName}.serie-docto   = cSerieDocto
                               and {&TableName}.nat-operacao  = cNatOperacao
                               and {&TableName}.quantidade    > 0
                               NO-LOCK indexed-reposition.


  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfEmitente DBOProgram 
PROCEDURE openQueryOfEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
                 &IF DEFINED(CUSTOM_GRENDENE) &THEN
                     USE-INDEX emit-item
                 &ENDIF
         where {&tableName}.cod-emitente  = i-cod-emitente
           and {&tableName}.cod-estabel   = c-estab
           and {&tablename}.it-codigo    >= c-item-ini
           and {&tablename}.it-codigo    <= c-item-fim
           and {&tableName}.serie-docto  >= c-serie-ini
           and {&tableName}.serie-docto  <= c-serie-fim
           and {&tableName}.nro-docto    >= c-nro-docto-ini
           and {&tableName}.nro-docto    <= c-nro-docto-fim
           and {&tableName}.nat-operacao >= c-nat-oper-ini
           and {&tableName}.nat-operacao <= c-nat-oper-fim
           and {&tableName}.dt-retorno   >= d-dt-retorno-ini
           and {&tableName}.dt-retorno   <= d-dt-retorno-fim
           and ( ( {&tableName}.quantidade > 0)
              or ( {&tableName}.quantidade = 0 and  l-saldo-zero) )
           and ( (   {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
                or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
                or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
                or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
                or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ) )
           no-lock
          &IF DEFINED(CUSTOM_GRENDENE) &THEN
               by {&tableName}.cod-emitente
               by {&tablename}.it-codigo
               by {&tableName}.nro-docto
           &ELSE
               by {&tablename}.it-codigo
               by {&tableName}.serie-docto
               by {&tableName}.nro-docto
               by {&tableName}.nat-operacao
               by {&tableName}.cod-emitente
               by {&tableName}.cod-refer
               by {&tableName}.sequencia
           &ENDIF               
           indexed-reposition.

    return "OK":U.                   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfEmitenteFutureDelivery DBOProgram 
PROCEDURE openQueryOfEmitenteFutureDelivery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
                 &IF DEFINED(CUSTOM_GRENDENE) &THEN
                     USE-INDEX emit-item
                 &ENDIF
         where {&tableName}.cod-emitente  = i-cod-emitente
           and {&tableName}.cod-estabel   = c-estab
           and {&tablename}.it-codigo    >= c-item-ini
           and {&tablename}.it-codigo    <= c-item-fim
           and {&tableName}.serie-docto  >= c-serie-ini
           and {&tableName}.serie-docto  <= c-serie-fim
           and {&tableName}.nro-docto    >= c-nro-docto-ini
           and {&tableName}.nro-docto    <= c-nro-docto-fim
           and {&tableName}.nat-operacao >= c-nat-oper-ini
           and {&tableName}.nat-operacao <= c-nat-oper-fim
           and {&tableName}.dt-retorno   >= d-dt-retorno-ini
           and {&tableName}.dt-retorno   <= d-dt-retorno-fim
           and ( ( {&tableName}.quantidade > 0)
              or ( {&tableName}.quantidade = 0 and  l-saldo-zero) )
           and (  (
                     ( {&tableName}.tipo-sal-terc = 1  and l-sai-benef ) 
                  or ( {&tableName}.tipo-sal-terc = 2  and l-ent-benef )
                  or ( {&tableName}.tipo-sal-terc = 3  and l-transf    ) 
                  or ( {&tableName}.tipo-sal-terc = 4  and l-sai-consig) 
                  or ( {&tableName}.tipo-sal-terc = 5  and l-ent-consig)
                  or ( {&tableName}.tipo-sal-terc = 7  and l-sai-dep-fech ) 
                  or ( {&tableName}.tipo-sal-terc = 8  and l-ent-dep-fech )
                  or ( {&tableName}.tipo-sal-terc = 9  and l-sai-armaz-ger) 
                  or ( {&tableName}.tipo-sal-terc = 10 and l-ent-armaz-ger)
                  ) AND NOT {&tableName}.log-entreg-fut
                    OR {&tableName}.log-entreg-fut AND l-ent-fut
               ) 
           no-lock
          &IF DEFINED(CUSTOM_GRENDENE) &THEN
               by {&tableName}.cod-emitente
               by {&tablename}.it-codigo
               by {&tableName}.nro-docto
           &ELSE
               by {&tablename}.it-codigo
               by {&tableName}.serie-docto
               by {&tableName}.nro-docto
               by {&tableName}.nat-operacao
               by {&tableName}.cod-emitente
               by {&tableName}.cod-refer
               by {&tableName}.sequencia
           &ENDIF               
           indexed-reposition.

    return "OK":U.                   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfEmitenteQtdeEq0 DBOProgram 
PROCEDURE openQueryOfEmitenteQtdeEq0 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente  = i-cod-emitente
           and {&tableName}.cod-estabel  >= c-estab
           and {&tablename}.it-codigo    >= c-item-ini
           and {&tablename}.it-codigo    <= c-item-fim
           and ({&tableName}.quantidade > 0 or l-saldo-zero)
           and ( ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
              or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
              or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
              or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
              or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig )) 
              no-lock
              INDEXED-REPOSITION.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItem DBOProgram 
PROCEDURE openQueryOfItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
                 &IF DEFINED(CUSTOM_GRENDENE) &THEN
                     USE-INDEX item-emit
                 &ENDIF
       where {&tablename}.it-codigo     = c-it-codigo
         and {&tableName}.cod-estabel   = c-estab
         and {&tableName}.cod-emitente >= i-emitente-ini
         and {&tableName}.cod-emitente <= i-emitente-fim
         and {&tableName}.serie-docto  >= c-serie-ini
         and {&tableName}.serie-docto  <= c-serie-fim
         and {&tableName}.nro-docto    >= c-nro-docto-ini
         and {&tableName}.nro-docto    <= c-nro-docto-fim
         and {&tableName}.nat-operacao >= c-nat-oper-ini
         and {&tableName}.nat-operacao <= c-nat-oper-fim
         and {&tableName}.dt-retorno   >= d-dt-retorno-ini
         and {&tableName}.dt-retorno   <= d-dt-retorno-fim
         and (   ( {&tableName}.quantidade > 0)
              or ( {&tableName}.quantidade = 0 and  l-saldo-zero) )
         and (   ( {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
              or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
              or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
              or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
              or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ) )
              no-lock
         &IF DEFINED(CUSTOM_GRENDENE) &THEN
              by {&tablename}.it-codigo
              by {&tableName}.cod-emitente
              by {&tableName}.nro-docto
         &ELSE     
              by {&tableName}.cod-emitente
              by {&tableName}.serie-docto
              by {&tableName}.nro-docto
              by {&tableName}.nat-operacao
              by {&tablename}.it-codigo
              by {&tableName}.cod-refer
              by {&tableName}.sequencia
         &ENDIF    
              indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemQtdeEq0 DBOProgram 
PROCEDURE openQueryOfItemQtdeEq0 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
          where {&tablename}.it-codigo     = c-it-codigo
           and {&tableName}.cod-estabel  >= c-estab
           and {&tableName}.cod-emitente >= i-emitente-ini
           and {&tableName}.cod-emitente <= i-emitente-fim
           and ({&tableName}.quantidade > 0 or l-saldo-zero)
           and ( (  {&tableName}.tipo-sal-terc = 1 and l-sai-benef  ) 
               or ( {&tableName}.tipo-sal-terc = 2 and l-ent-benef  )
               or ( {&tableName}.tipo-sal-terc = 3 and l-transf     ) 
               or ( {&tableName}.tipo-sal-terc = 4 and l-sai-consig ) 
               or ( {&tableName}.tipo-sal-terc = 5 and l-ent-consig ))
               no-lock
               indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryofZoomTercEntregFutPage1 DBOProgram 
PROCEDURE openQueryofZoomTercEntregFutPage1 :
/*------------------------------------------------------------------------------
  Notes: abre a query conforme dados enviados para a procedure 
         setConstraintofZoomTercPage1
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente  =  iEmitente
           and {&tableName}.cod-estabel   =  c-estab
           and {&tableName}.tipo-sal-terc =  iTipoSaldTerc
           and {&tableName}.nro-docto     >= cDocIni
           and {&tableName}.nro-docto     <= cDocFim
           and {&tableName}.nat-operacao  >= cNatOperIni
           and {&tableName}.nat-operacao  <= cNatOperFim
           and {&tableName}.quantidade     > 0
           and {&tableName}.log-entreg-fut
           no-lock

           by {&tableName}.serie-docto
           by {&tableName}.nro-docto
           by {&tableName}.nat-operacao
           by {&tablename}.it-codigo
           by {&tableName}.cod-emitente
           by {&tableName}.cod-refer
           by {&tableName}.sequencia          

           indexed-reposition.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryofZoomTercEntregFutPage2 DBOProgram 
PROCEDURE openQueryofZoomTercEntregFutPage2 :
/*------------------------------------------------------------------------------
  Notes: abre a query conforme dados enviados para a procedure 
         setConstraintofZoomTercPage2
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente  =  iEmitente
           and {&tableName}.cod-estabel   =  c-estab
           and {&tableName}.tipo-sal-terc =  iTipoSaldTerc
           and {&tablename}.it-codigo     >= cItemIni
           and {&tablename}.it-codigo     <= cItemFim
           and {&tableName}.quantidade     > 0
           and {&tableName}.log-entreg-fut
           no-lock
           by {&tablename}.it-codigo
           by {&tableName}.serie-docto
           by {&tableName}.nro-docto
           by {&tableName}.nat-operacao
           by {&tableName}.cod-emitente              
           by {&tableName}.cod-refer
           by {&tableName}.sequencia           
           indexed-reposition. 

    return "OK":U.

END PROCEDURE.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryofZoomTercPage1 DBOProgram 
PROCEDURE openQueryofZoomTercPage1 :
/*------------------------------------------------------------------------------
  Notes: abre a query conforme dados enviados para a procedure 
         setConstraintofZoomTercPage1
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente  =  iEmitente
           and {&tableName}.cod-estabel   =  c-estab
           and {&tableName}.tipo-sal-terc =  iTipoSaldTerc
           and {&tableName}.nro-docto     >= cDocIni
           and {&tableName}.nro-docto     <= cDocFim
           and {&tableName}.nat-operacao  >= cNatOperIni
           and {&tableName}.nat-operacao  <= cNatOperFim
           and {&tableName}.quantidade     > 0
           AND {&tableName}.log-entreg-fut = lRemEntFutura
           no-lock

           by {&tableName}.nro-docto
           by {&tableName}.serie-docto           
           by {&tableName}.nat-operacao
           by {&tablename}.it-codigo
           by {&tableName}.cod-emitente
           by {&tableName}.cod-refer
           by {&tableName}.sequencia          

           indexed-reposition.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryofZoomTercPage2 DBOProgram 
PROCEDURE openQueryofZoomTercPage2 :
/*------------------------------------------------------------------------------
  Notes: abre a query conforme dados enviados para a procedure 
         setConstraintofZoomTercPage2
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente  =  iEmitente
           and {&tableName}.cod-estabel   =  c-estab
           and {&tableName}.tipo-sal-terc =  iTipoSaldTerc
           and {&tablename}.it-codigo     >= cItemIni
           and {&tablename}.it-codigo     <= cItemFim
           and {&tableName}.quantidade     > 0
           AND {&tableName}.log-entreg-fut = lRemEntFutura
           no-lock
           by {&tablename}.it-codigo
           by {&tableName}.nro-docto
           by {&tableName}.serie-docto           
           by {&tableName}.nat-operacao
           by {&tableName}.cod-emitente              
           by {&tableName}.cod-refer
           by {&tableName}.sequencia           
           indexed-reposition. 

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRangeEmitente DBOProgram 
PROCEDURE OpenQueryRangeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    open query qr{&tableName} for each {&tableName}
          where {&tableName}.cod-estabel   = c-estab-ini
            and {&tableName}.cod-emitente >= i-emitente-ini
            and {&tableName}.cod-emitente <= i-emitente-fim
            no-lock
            by {&tableName}.cod-emitente
            by {&tableName}.cod-estabel
            BY {&tableName}.serie-docto
            by {&tableName}.nro-docto
            by {&tablename}.it-codigo
            by {&tableName}.nat-operacao
            by {&tableName}.sequencia.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRangeEmitente2 DBOProgram 
PROCEDURE OpenQueryRangeEmitente2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY qr{&tableName} 
        FOR EACH {&tableName} WHERE 
                 {&tableName}.cod-emitente >= i-emitente-ini  AND 
                 {&tableName}.cod-emitente <= i-emitente-fim  AND 
                 {&tableName}.cod-estabel  >= c-estab-ini     AND 
                 {&tableName}.cod-estabel  <= c-estab-fim     NO-LOCK
        &IF DEFINED(CUSTOM_GRENDENE) &THEN
            USE-INDEX emit-item
        &ELSE
            by {&tableName}.cod-emitente
            by {&tableName}.cod-estabel
            by {&tableName}.sequencia
            by {&tableName}.nro-docto
         &ENDIF
            INDEXED-REPOSITION.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRangeItem DBOProgram 
PROCEDURE OpenQueryRangeItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    open query qr{&tableName} 
            FOR EACH {&tableName} WHERE 
                     {&tableName}.cod-estabel  = c-estab-ini AND 
                     {&tablename}.it-codigo   >= c-item-ini  AND 
                     {&tablename}.it-codigo   <= c-item-fim  NO-LOCK
              BY {&tablename}.it-codigo ~
              BY {&tableName}.cod-emitente ~
              BY {&tableName}.cod-estabel ~
              BY {&tableName}.serie-docto ~
              BY {&tableName}.nro-docto ~
              BY {&tableName}.nat-operacao ~
              BY {&tableName}.sequencia 
              INDEXED-REPOSITION.
    return "OK":U.           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRangeItem2 DBOProgram 
PROCEDURE OpenQueryRangeItem2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} 
            FOR EACH {&tableName} WHERE 
                     {&tablename}.it-codigo   >= c-item-ini   AND 
                     {&tablename}.it-codigo   <= c-item-fim   AND 
                     {&tableName}.cod-estabel  >= c-estab-ini AND 
                     {&tableName}.cod-estabel  <= c-estab-fim NO-LOCK
          &IF DEFINED(CUSTOM_GRENDENE) &THEN
              USE-INDEX item-emit
         &ELSE
              by {&tablename}.it-codigo
              by {&tableName}.cod-estabel
              by {&tableName}.sequencia
              by {&tableName}.nro-docto
         &ENDIF
            INDEXED-REPOSITION.
    return "OK":U.           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerysaldoNotas DBOProgram 
PROCEDURE openQuerysaldoNotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
            where {&tablename}.it-codigo = c-it-codigo 
            and   {&tableName}.cod-emitente = iEmitente 
            indexed-reposition.

     return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryToSaldoTercItem DBOProgram 
PROCEDURE openQueryToSaldoTercItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
            where {&tablename}.it-codigo = c-it-codigo 
            indexed-reposition.

     return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE re1001_PrecoTotal DBOProgram 
PROCEDURE re1001_PrecoTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piDataTrans      like componente.dt-retorno            no-undo.
    def input  param piProporcao      as dec                                no-undo.
    def input  param piQtdeItem       like componente.quantidade            no-undo.
    def output param piPrecoTotal     like componente.preco-total[1]        no-undo.
    def output param piDesconto       like componente.desconto[1]           no-undo.

    def var de-valor-tot              like componente.preco-total extent 0  no-undo.
    def var de-desc-tot               like componente.desconto    extent 0  no-undo.

    for first componente 
        fields ( cod-emitente nro-docto serie-docto 
                 nat-operacao it-codigo cod-refer 
                 sequencia preco-total[1] desconto[1] )
        of RowObject no-lock.
    end.         

    find b-natur-oper
        where b-natur-oper.nat-operacao = RowObject.nat-operacao no-lock no-error.

    assign de-valor-tot  = componente.preco-total[1]
           de-desc-tot   = componente.desconto[1].

    for each b-componente
        fields ( quantidade dt-retorno componente
                 preco-total[1] desconto[1] )
        where b-componente.cod-emitente = componente.cod-emitente 
          and b-componente.nro-comp     = componente.nro-docto    
          and b-componente.serie-comp   = componente.serie-docto  
          and b-componente.nat-comp     = componente.nat-operacao 
          and b-componente.it-codigo    = componente.it-codigo    
          and b-componente.cod-refer    = componente.cod-refer   
          and b-componente.seq-comp     = componente.sequencia   no-lock:

        /* Considera Nota de Reajuste de Preco somente ate Data da Nota */
        if  b-componente.quantidade <> 0
        or  b-componente.dt-retorno <= piDataTrans then do:

            if  b-componente.componente = 1 then 
                assign de-valor-tot = de-valor-tot + b-componente.preco-total[1]
                       de-desc-tot  = de-desc-tot  + b-componente.desconto[1].
            else 
                assign de-valor-tot = de-valor-tot - b-componente.preco-total[1]
                       de-desc-tot  = de-desc-tot  - b-componente.desconto[1].
        end.            
    end.

    if  b-natur-oper.tp-oper-terc <> 6 then  /* Diferente de Reajuste Preco */
        assign piPrecoTotal = ( de-valor-tot / RowObject.quantidade ) * piQtdeItem
               piDesconto   = ( de-desc-tot  / RowObject.quantidade ) * piQtdeItem.
    else
        assign piPrecoTotal = de-valor-tot * piProporcao
               piDesconto   = de-desc-tot  * piProporcao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE re1001_QuantReceb DBOProgram 
PROCEDURE re1001_QuantReceb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piProporcao      as dec                     no-undo.
    def output param piQuantidade     like saldo-terc.quantidade no-undo.

    if  avail RowObject then do:

        assign piQuantidade = (( RowObject.quantidade - RowObject.dec-1 ) 
                                 * piProporcao ) / 100.

        if  piQuantidade <= 0 then 
            assign piQuantidade = 0.
    end.
    else 
        assign piQuantidade = 0.


    RETURN "OK":U.                    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaSaldoTerc DBOProgram 
PROCEDURE retornaSaldoTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  pnatoperacao AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pSaldoTerc   AS INTEGER   NO-UNDO.

      find first natur-oper where natur-oper.nat-operacao = pnatoperacao no-lock no-error.
      if avail natur-oper then do:
         {cdp/cd4398.i4}
         assign pSaldoTerc = i-tipo-sal-terc.   
      end.      


    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnQtde DBOProgram 
PROCEDURE returnQtde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAM QTDE   AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAM QTALOC AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAM VALOR  AS DECIMAL NO-UNDO.

    def var dVal as decimal no-undo.

    FOR EACH  bf{&tableName} /* FIELDS( serie-docto nro-docto cod-emitente nat-operacao
                                      it-codigo cod-refer sequencia quantidade dec-1
                                      valor-mat-m valor-mob-m valor-ggf-m ) */
        WHERE bf{&tablename}.it-codigo     = {&tablename}.it-codigo     
          AND bf{&tableName}.cod-emitente  = {&TableName}.cod-emitente  
          AND bf{&tableName}.cod-estabel   = {&TableName}.cod-estabel   
          AND bf{&tableName}.tipo-sal-terc = {&TableName}.tipo-sal-terc 
          AND bf{&tableName}.serie-docto  >= cSerieIni      
          AND bf{&tableName}.serie-docto  <= cSerieFim      
          AND bf{&tableName}.nro-docto    >= cNroDoctoIni  
          AND bf{&tableName}.nro-docto    <= cNroDoctoFim  
          AND bf{&tableName}.nat-operacao >= cNat-OperIni   
          AND bf{&tableName}.nat-operacao <= cNat-OperFim   
          AND bf{&tableName}.dt-retorno   >= dDtRetornoIni 
          AND bf{&tableName}.dt-retorno   <= dDtRetornoFim NO-LOCK:

            ASSIGN QTDE     = QTDE   + bf{&tableName}.quantidade 
                   QTALOC   = QTALOC + bf{&tableName}.dec-1.

            IF  l-preco-medio THEN DO:
                ASSIGN VALOR    = VALOR + 
                                  ((bf{&tableName}.valor-mat-m[1] + bf{&tableName}.valor-mob-m[1] 
                                   + bf{&tableName}.valor-ggf-m[1]) * bf{&tableName}.quantidade).
            END.
            ELSE DO:
                FOR FIRST componente FIELDS ( preco-total[1] quantidade ) 
                    OF bf{&tableName} NO-LOCK:
                    ASSIGN VALOR = (componente.preco-total[1])
                                    + VALOR.
                END.
            END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saldoTerc DBOProgram 
PROCEDURE saldoTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM c-it-codigo like item.it-codigo.
    DEF INPUT  PARAM dt-saldo    like movto-estoq.dt-trans.
    DEF OUTPUT PARAM TABLE FOR tt-saldo-terc.

    for each tt-saldo-terc:
        delete tt-saldo-terc.
    end.

    if dt-saldo = ? then
       dt-saldo = today.

    for each saldo-terc where saldo-terc.it-codigo     = c-it-codigo no-lock,
      first movto-estoq where movto-estoq.it-codigo    = saldo-terc.it-codigo
                          and movto-estoq.cod-estabel  = saldo-terc.cod-estabel
                          and movto-estoq.cod-refer    = saldo-terc.cod-refer
                          and movto-estoq.cod-emitente = saldo-terc.cod-emitente
                          and movto-estoq.dt-trans    <= dt-saldo no-lock:


        create tt-saldo-terc.
        assign tt-saldo-terc.cod-emitente = saldo-terc.cod-emitente
               tt-saldo-terc.nro-docto    = saldo-terc.nro-docto
               tt-saldo-terc.serie-docto  = saldo-terc.serie-docto
               tt-saldo-terc.cod-estabel  = saldo-terc.cod-estabel
               tt-saldo-terc.quantidade   = saldo-terc.quantidade.
    end.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyItem DBOProgram 
PROCEDURE setConstraintbyItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: chamada pelo wz08in404       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodEstabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pEmitente      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pDocIni        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pDocFim        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pNatOperIni    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pNatOperFim    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pItemIni       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pItemFim       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pitiposaldterc AS INTEGER NO-UNDO.

    assign cCodEstabel   =  pCodEstabel
           iEmitente     =  pEmitente
           cDocIni       =  pDocIni   
           cDocFim       =  pDocFim   
           cNatOperIni   =  pNatOperIni
           cNatOperFim   =  pNatOperFim
           cItemIni      =  pItemIni   
           cItemFim      =  pItemFim
           itiposaldterc = pitiposaldterc.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmitente DBOProgram 
PROCEDURE setConstraintEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter pCodEmit    as inte no-undo.
    define input parameter pCallerProg as char no-undo.
    define input parameter pCodEstab   as char no-undo.
    define input parameter pItemIni    as char no-undo.    
    define input parameter pItemFim    as char no-undo.    
    define input parameter pSerieIni     like {&tableName}.serie-docto  no-undo.
    define input parameter pSerieFim     like {&tableName}.serie-docto  no-undo.
    define input parameter pNroDoctoIni  like {&tableName}.nro-docto    no-undo.
    define input parameter pNroDoctoFim  like {&tableName}.nro-docto    no-undo.
    define input parameter pNatOperIni   like {&tableName}.nat-operacao no-undo.
    define input parameter pNatOperFim   like {&tableName}.nat-operacao no-undo.
    define input parameter pDtRetornoIni like {&tableName}.dt-retorno   no-undo.
    define input parameter pDtRetornoFim like {&tableName}.dt-retorno   no-undo.

    assign iCodEmit      = pCodEmit
           cCallerProg   = pCallerProg
           cCodEstab     = pCodEstab  
           cItemIni      = pItemIni
           cItemFim      = pItemFim
           cSerieIni     = pSerieIni
           cSerieFim     = pSerieFim
           cNroDoctoIni  = pNroDoctoIni
           cNroDoctoFim  = pNroDoctoFim
           cNat-OperIni  = pNatOperIni
           cNat-OperFim  = pNatOperFim
           dDtRetornoIni = pDtRetornoIni
           dDtRetornoFim = pDtRetornoFim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter pItCodigo     as char no-undo.
    define input parameter pCallerProg   as char no-undo.
    define input parameter pCodEstab     as char no-undo.
    define input parameter pCodEmitIni   as inte no-undo.
    define input parameter pCodEmitFim   as inte no-undo.
    define input parameter pSerieIni     like {&tableName}.serie-docto  no-undo.
    define input parameter pSerieFim     like {&tableName}.serie-docto  no-undo.
    define input parameter pNroDoctoIni  like {&tableName}.nro-docto    no-undo.
    define input parameter pNroDoctoFim  like {&tableName}.nro-docto    no-undo.
    define input parameter pNatOperIni   like {&tableName}.nat-operacao no-undo.
    define input parameter pNatOperFim   like {&tableName}.nat-operacao no-undo.
    define input parameter pDtRetornoIni like {&tableName}.dt-retorno   no-undo.
    define input parameter pDtRetornoFim like {&tableName}.dt-retorno   no-undo.

    assign cItCodigo     = pItCodigo
           cCallerProg   = pCallerProg
           cCodEstab     = pCodEstab  
           iCodEmitIni   = pCodEmitIni
           iCodEmitFim   = pCodEmitFim
           cSerieIni     = pSerieIni
           cSerieFim     = pSerieFim
           cNroDoctoIni  = pNroDoctoIni
           cNroDoctoFim  = pNroDoctoFim
           cNat-OperIni   = pNatOperIni
           cNat-OperFim   = pNatOperFim
           dDtRetornoIni = pDtRetornoIni
           dDtRetornoFim = pDtRetornoFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintofDocumento DBOProgram 
PROCEDURE setConstraintofDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pEmitente      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pSerieDocto    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pNroDocto      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pNatOperacao   AS CHARACTER NO-UNDO.


    assign iEmitente    = pEmitente
           cNroDocto    = pNroDocto
           cSerieDocto  = pSerieDocto
           cNatOperacao = pNatOperacao.

    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfEmitente DBOProgram 
PROCEDURE setConstraintOfEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:   chamada pelo re0706 
------------------------------------------------------------------------------*/

    def input parameter p-cod-emit    as int no-undo.

    assign i-cod-emitente   = p-cod-emit.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfItem DBOProgram 
PROCEDURE setConstraintOfItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:      chamada pelo re0702 e re0706 
------------------------------------------------------------------------------*/

    def input param p-it-codigo       as char    no-undo.

    assign c-it-codigo      = p-it-codigo.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintofZoomTercPage1 DBOProgram 
PROCEDURE setConstraintofZoomTercPage1 :
/*------------------------------------------------------------------------------
  Parameters: piNroDoctoIni - nro docto inicial da pag 1
              piNroDoctoEnd - nro docto final da pag 1
              piNatOperIni  - nat operacao inicial da pag 1
              piNatOperEnd  - nat operacao final da pag 1
              piCodEmitente - codigo do emitente
              piCodEstabel  - codigo do estabelecimento
              piTipoSaldo   - Tipo do sado Terceiros
  Notes: recebe os valores iniciais e finais dos campos nro-docto e nat-operacao
         que serao usados na abertura da query openQueryofZoomTercPage1.
------------------------------------------------------------------------------*/

    def input param piNroDoctoIni like saldo-terc.nro-docto     no-undo.
    def input param piNroDoctoEnd like saldo-terc.nro-docto     no-undo.
    def input param piNatOperIni  like saldo-terc.nat-operacao  no-undo.
    def input param piNatOperEnd  like saldo-terc.nat-operacao  no-undo.
    def input param piCodEmitente like saldo-terc.cod-emitente  no-undo.
    def input param piCodEstabel  like saldo-terc.cod-estabel   no-undo.
    def input param piTipoSaldo   like saldo-terc.tipo-sal-terc no-undo.
    DEF INPUT PARAM plRemEntFutura  AS LOG                      NO-UNDO.

    assign cDocIni       = piNroDoctoIni
           cDocFim       = piNroDoctoEnd
           cNatOperIni   = piNatOperIni
           cNatOperFim   = piNatOperEnd
           iEmitente     = piCodEmitente
           c-estab       = piCodEstabel
           iTipoSaldTerc = piTipoSaldo
           lRemEntFutura = plRemEntFutura. 

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintofZoomTercPage2 DBOProgram 
PROCEDURE setConstraintofZoomTercPage2 :
/*------------------------------------------------------------------------------
  Parameters: piItemIni     - codigo do item inicial da pag 2
              piItemEnd     - codigo do item final da pag 2
              piCodEmitente - codigo do emitente
              piCodEstabel  - codigo do estabelecimento
              piTipoSaldo   - Tipo do sado Terceiros

  Notes: recebe o valor inicial e final do campo it-codigo que sera usado na 
         abertura da query openQueryofZoomTercPage2.
------------------------------------------------------------------------------*/

    def input param piItemIni     like saldo-terc.it-codigo     no-undo.
    def input param piItemEnd     like saldo-terc.it-codigo     no-undo.
    def input param piCodEmitente like saldo-terc.cod-emitente  no-undo.
    def input param piCodEstabel  like saldo-terc.cod-estabel   no-undo.
    def input param piTipoSaldo   like saldo-terc.tipo-sal-terc no-undo.
    DEF INPUT PARAM plRemEntFutura  AS LOG                      NO-UNDO.

    assign cItemIni      = piItemIni
           cItemFim      = piItemEnd
           iEmitente     = piCodEmitente
           c-estab       = piCodEstabel
           iTipoSaldTerc = piTipoSaldo
           lRemEntFutura = plRemEntFutura. 

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeEmitente DBOProgram 
PROCEDURE setConstraintRangeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes: chamada pelo zoom z10in404 pag.1
------------------------------------------------------------------------------*/

    def input param pi-estab-ini      as char no-undo.
    def input param pi-emit-ini       as int no-undo.
    def input param pi-emit-fim       as int no-undo.

    assign c-estab-ini     = pi-estab-ini
           i-emitente-ini  = pi-emit-ini
           i-emitente-fim  = pi-emit-fim.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeEmitente2 DBOProgram 
PROCEDURE setConstraintRangeEmitente2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes: chamada pelo zoom z10in404 pag.1
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcEstabIni AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEstabFim AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER piEmitIni  AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER piEmitFim  AS INTEGER NO-UNDO.

    assign c-estab-ini     = pcEstabIni
           c-estab-fim     = pcEstabFim
           i-emitente-ini  = piEmitIni 
           i-emitente-fim  = piEmitFim .

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeItem DBOProgram 
PROCEDURE setConstraintRangeItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes: chamada pelo zoom z10in404 pag.2
------------------------------------------------------------------------------*/

    def input param pi-estab-ini      as char    no-undo.
    def input param pi-item-ini       as char    no-undo.
    def input param pi-item-fim       as char    no-undo.

    assign c-estab-ini    = pi-estab-ini
           c-item-ini     = pi-item-ini
           c-item-fim     = pi-item-fim.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeItem2 DBOProgram 
PROCEDURE setConstraintRangeItem2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes: chamada pelo zoom z10in404 pag.2
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEstabIni AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER pcEstabFim AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER pcItemIni  AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER pcItemFim  AS CHAR    NO-UNDO.

    assign c-estab-ini = pcEstabIni
           c-estab-fim = pcEstabFim
           c-item-ini  = pcItemIni 
           c-item-fim  = pcItemFim  .

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSaldoNotas DBOProgram 
PROCEDURE setConstraintSaldoNotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: chamada pelo eb0107.w       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pitem          AS char      NO-UNDO.
    DEFINE INPUT PARAMETER pEmitente      AS INTEGER   NO-UNDO.

    assign iEmitente     =  pEmitente
           c-it-codigo   =  pitem.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintToSaldoTercItem DBOProgram 
PROCEDURE setConstraintToSaldoTercItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: chamada pelo eb0301.w
------------------------------------------------------------------------------*/

    def input param p-it-codigo as char no-undo.

    assign c-it-codigo = p-it-codigo.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameterFutureDelivery DBOProgram 
PROCEDURE setParameterFutureDelivery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pi-ent-fut      as logical no-undo.

    assign l-ent-fut      = pi-ent-fut.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters DBOProgram 
PROCEDURE setParameters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pi-sai-benef      as logical no-undo.
    def input param pi-ent-benef      as logical no-undo.
    def input param pi-transf         as logical no-undo.
    def input param pi-sai-consig     as logical no-undo.
    def input param pi-ent-consig     as logical no-undo.
    def input param pi-preco-medio    as logical no-undo.
    def input param pi-saldo-zero     as logical no-undo.

    assign l-sai-benef      = pi-sai-benef
           l-ent-benef      = pi-ent-benef
           l-transf         = pi-transf
           l-sai-consig     = pi-sai-consig
           l-ent-consig     = pi-ent-consig
           l-preco-medio    = pi-preco-medio
           l-saldo-zero     = pi-saldo-zero.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters2 DBOProgram 
PROCEDURE setParameters2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pi-sai-dep-fech  as logical no-undo.
    def input param pi-ent-dep-fech  as logical no-undo.
    def input param pi-sai-armaz-ger as logical no-undo.
    def input param pi-ent-armaz-ger as logical no-undo.

    assign l-sai-dep-fech  = pi-sai-dep-fech
           l-ent-dep-fech  = pi-ent-dep-fech
           l-sai-armaz-ger = pi-sai-armaz-ger
           l-ent-armaz-ger = pi-ent-armaz-ger.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSelection DBOProgram 
PROCEDURE setSelection :
/*------------------------------------------------------------------------------
  Parameters:
  Notes: Este m‚todo ‚ executado pelos programas re0702, re0706, re0703 e re0707.
         Logo ap¢s executar este m‚todo que defini os valores da vari veis ser 
         executado o "openQueryOfItem" no caso do re0702 e re0706 e
         "opeQueryOfEmitente" no caso do re0703 e re0707.
------------------------------------------------------------------------------*/

    def input param pi-estab          like {&tableName}.cod-estabel  no-undo.
    def input param pi-it-codigo-ini  like {&tablename}.it-codigo    no-undo.
    def input param pi-it-codigo-fim  like {&tablename}.it-codigo    no-undo.
    def input param pi-emitente-ini   like {&tableName}.cod-emitente no-undo.
    def input param pi-emitente-fim   like {&tableName}.cod-emitente no-undo.
    def input param pi-serie-ini      like {&tableName}.serie-docto  no-undo.
    def input param pi-serie-fim      like {&tableName}.serie-docto  no-undo.
    def input param pi-nro-docto-ini  like {&tableName}.nro-docto    no-undo.
    def input param pi-nro-docto-fim  like {&tableName}.nro-docto    no-undo.
    def input param pi-nat-oper-ini   like {&tableName}.nat-operacao no-undo.
    def input param pi-nat-oper-fim   like {&tableName}.nat-operacao no-undo.
    def input param pi-dt-retorno-ini like {&tableName}.dt-retorno   no-undo.
    def input param pi-dt-retorno-fim like {&tableName}.dt-retorno   no-undo.

    assign c-estab          = pi-estab
           c-item-ini       = pi-it-codigo-ini
           c-item-fim       = pi-it-codigo-fim
           i-emitente-ini   = pi-emitente-ini
           i-emitente-fim   = pi-emitente-fim
           c-serie-ini      = pi-serie-ini
           c-serie-fim      = pi-serie-fim
           c-nro-docto-ini  = pi-nro-docto-ini
           c-nro-docto-fim  = pi-nro-docto-fim
           c-nat-oper-ini   = pi-nat-oper-ini
           c-nat-oper-fim   = pi-nat-oper-fim
           d-dt-retorno-ini = pi-dt-retorno-ini
           d-dt-retorno-fim = pi-dt-retorno-fim.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaTipoNatOperacao DBOProgram 
PROCEDURE verificaTipoNatOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT   PARAM piNatOperacao          LIKE natur-oper.nat-operacao  NO-UNDO.
    DEF OUTPUT  PARAM pl-fatura-fat-antecip  AS LOG NO-UNDO.
    DEF OUTPUT  PARAM pl-remessa-fat-antecip AS LOG NO-UNDO.
    DEF OUTPUT  PARAM pl-fatura-ent-futura   AS LOG NO-UNDO.
    DEF OUTPUT  PARAM pl-remessa-ent-futura  AS LOG NO-UNDO.

    FOR FIRST natur-oper 
        WHERE natur-oper.nat-operacao = piNatOperacao NO-LOCK: END.

    IF AVAIL natur-oper THEN DO:
    
        /*--- identifica se a natureza do docum-est eh fatura faturamento antecipado, 
        remessa faturamento antecipado, fatura ent futura ou remessa ent futura ---*/    
        {cdp/cd9700.i1 natur-oper}
                
        ASSIGN pl-fatura-fat-antecip  = l-fatura-fat-antecip 
               pl-remessa-fat-antecip = l-remessa-fat-antecip
               pl-fatura-ent-futura   = l-fatura-ent-futura  
               pl-remessa-ent-futura  = l-remessa-ent-futura .
    END.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


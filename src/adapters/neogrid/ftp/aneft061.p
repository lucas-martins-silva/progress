/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT061 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEFT061 MFT}
&ENDIF


/******************************************************************************
**  Programa: ANEFT061.p
**  Funcao  : Sender de Cotaá‰es de Moedas
**  Data    : 05/2003
**  Autor   : Liziane Leite
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

{utp/ut-glob.i}

DEFINE INPUT  PARAMETER r-cotacao  AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER changecode AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-root                           AS CHAR NO-UNDO. 
DEFINE VARIABLE c-message                        AS CHAR NO-UNDO.
DEFINE VARIABLE c-CurrencyExchangeRate           AS CHAR NO-UNDO.
DEFINE VARIABLE c-ExchangeRateInformationCollec  AS CHAR NO-UNDO. /* TAG ExchangeRateInformationCollection */
DEFINE VARIABLE c-ExchangeRateInformation        AS CHAR NO-UNDO.
DEFINE VARIABLE c-ExchRatePeriodInfoCollection   AS CHAR NO-UNDO.
DEFINE VARIABLE c-ExchRatePeriodInfo             AS CHAR NO-UNDO.
DEFINE VARIABLE c-ExchangeRateCollection         AS CHAR NO-UNDO.
DEFINE VARIABLE c-campo                          AS CHAR NO-UNDO.
DEFINE VARIABLE c-FromRole                       AS CHAR NO-UNDO.
DEFINE VARIABLE c-ToRole                         AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  r-cotacao <> ? THEN
    FIND cotacao WHERE ROWID(cotacao) = r-cotacao NO-LOCK NO-ERROR.
    IF  AVAIL cotacao THEN
        RUN pi-corpo-msg.
    
RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("CurrencyExchangeRate","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-campo = AddEleChar(c-message,"TransactionType",changecode)
               c-ExchangeRateInformationCollec = AddElement(c-message,"ExchangeRateInformationCollection")
               c-FromRole                      = AddElement(c-message,"FromRole")
               c-ToRole                        = AddElement(c-message,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:

    FOR FIRST moeda FIELDS(descricao) WHERE moeda.mo-codigo = cotacao.mo-codigo NO-LOCK:
    END.
    
    ASSIGN c-ExchangeRateInformation = AddElement(c-ExchangeRateInformationCollec,"ExchangeRateInformation")
             c-campo = AddEleInt(c-ExchangeRateInformation,"CurrencyCode",cotacao.mo-codigo)
             c-campo = AddEleChar(c-ExchangeRateInformation,"CurrencyDescription",if avail moeda then moeda.descricao else "").

    ASSIGN c-ExchRatePeriodInfoCollection = AddElement(c-ExchangeRateInformation,"ExchRatePeriodInfoCollection")
             c-ExchRatePeriodInfo = AddElement(c-ExchRatePeriodInfoCollection,"ExchRatePeriodInfo")
               c-campo = AddEleDeci(c-ExchRatePeriodInfo,"AverageExchangeRate",cotacao.cota-media)
               c-campo = AddEleDeci(c-ExchRatePeriodInfo,"MonthlyRate",cotacao.cota-mensal)
               c-campo = AddEleChar(c-ExchRatePeriodInfo,"ExchangeRatePeriod",string(cotacao.ano-periodo,"9999-99")) /* No dicion†rio formato 9999/99, mas o padr∆o XML Ç 9999-99 */
                 c-ExchangeRateCollection = AddElement(c-ExchRatePeriodInfo,"ExchangeRateCollection").
    
    RUN pi-ExchangeRate-msg.
    
END PROCEDURE.

PROCEDURE pi-ExchangeRate-msg:

    DEFINE VARIABLE c-ExchangeRate  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER    NO-UNDO.
    DEFINE VARIABLE i-ano           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE i-mes           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE i-fim-mes       AS INTEGER    NO-UNDO.
    
    /* Tratamento para £ltimo dia do màs(per°odo) */
    ASSIGN i-ano = int(substring(cotacao.ano-periodo,1,4))
           i-mes = int(substring(cotacao.ano-periodo,5,2)).
    
    IF  i-mes = 1
    OR  i-mes = 3
    OR  i-mes = 5
    OR  i-mes = 7
    OR  i-mes = 8
    OR  i-mes = 10
    OR  i-mes = 12 THEN
        ASSIGN i-fim-mes = 31.
            
    IF  i-mes = 4
    OR  i-mes = 6
    OR  i-mes = 9
    OR  i-mes = 11 THEN
        ASSIGN i-fim-mes = 30.
            
    /* condiá∆o para ano bissexto */
    IF  i-mes = 2 THEN DO:
        IF  DECIMAL(i-ano / 4) = INTEGER(i-ano / 4) THEN DO:
            IF  DECIMAL(i-ano / 100) = INTEGER(i-ano / 100) THEN DO:
                IF  DECIMAL(i-ano / 400) = INTEGER(i-ano / 400) THEN
                    ASSIGN i-fim-mes = 29.
                ELSE
                    ASSIGN i-fim-mes = 28.    
            END.
            ELSE
                ASSIGN i-fim-mes = 29.
        END.
        ELSE
            ASSIGN i-fim-mes = 28.
    END.

    

    DO  i-cont = 1 TO i-fim-mes:
        ASSIGN c-ExchangeRate = AddElement(c-ExchangeRateCollection,"ExchangeRate")
               c-campo = AddEleInt(c-ExchangeRate,"ExchangeRateDay",i-cont)
               c-campo = AddEleDeci(c-ExchangeRate,"ExchangeRateValue",cotacao.cotacao[i-cont]).
    END.

END PROCEDURE.

PROCEDURE pi-rodape-msg:

    DEFINE VARIABLE c-Address AS CHARACTER  NO-UNDO.

    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier","")
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER").

    FOR FIRST empresa FIELDS (endereco endereco-2 cidade bairro uf pais cep)
        WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK:
    END.

    ASSIGN c-Address = AddElement(c-FromRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1",if avail empresa then empresa.endereco else "")
             c-campo = AddEleChar(c-Address,"AddressLine2",if avail empresa then empresa.endereco-2 else "")
             c-campo = AddEleChar(c-Address,"CityName",if avail empresa then empresa.cidade else "")
             c-campo = AddEleChar(c-Address,"DistrictName",if avail empresa then empresa.bairro else "")
             c-campo = AddEleChar(c-Address,"StateCode",if avail empresa then empresa.uf else "")
             c-campo = AddEleChar(c-Address,"LegacyCountryCode",if avail empresa then empresa.pais else "")
             c-campo = AddEleChar(c-Address,"NationalPostalCode",if avail empresa then empresa.cep else "").

             
    ASSIGN c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier","")
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","").

    ASSIGN c-Address = AddElement(c-ToRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1","")
             c-campo = AddEleChar(c-Address,"AddressLine2","")
             c-campo = AddEleChar(c-Address,"CityName","")
             c-campo = AddEleChar(c-Address,"DistrictName","")
             c-campo = AddEleChar(c-Address,"StateCode","")
             c-campo = AddEleChar(c-Address,"LegacyCountryCode","")
             c-campo = AddEleChar(c-Address,"NationalPostalCode","").

END PROCEDURE.

&ENDIF

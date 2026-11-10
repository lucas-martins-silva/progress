/* teste */
USING PROGRESS.Lang.*.
USING OpenEdge.Core.*.
USING OpenEdge.Net.HTTP.*.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.

USING System.Text.*.
USING System.IO.*.
USING System.Net.*.

USING System.Security.Cryptography.X509Certificates.*.
USING System.Security.Cryptography.*.
/* fim teste */

USING System.*.
USING System.Net.WebRequest.
USING System.Net.HttpWebRequest.
USING System.Security.Cryptography.X509Certificates.X509Certificate2.
USING System.Security.Cryptography.CryptographicException.
USING System.Net.WebException.
USING System.Exception.

USING PROGRESS.json.*.
USING PROGRESS.json.ObjectModel.*.
USING com.totvs.framework.api.*.
USING PROGRESS.Json.ObjectModel.ObjectModelParser.
/********************************************************************************
** Copyright TOTVS S.A. (2017)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquenarrativar meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i IMAPI019 1.00.00.015} /*** "010015" 01/10/2026 09:25:03 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imapi019 MIM}
&ENDIF

/*****************************************************************************
**
**       Programa: imapi019.p       
**
**       Data....: 05/2021  
**
**       Autor...: SQUAD - DMANSUPCEX  
**
**       Objetivo: Geraá∆o de dados via JSON para a integraá∆o com o 
**                 portal siscomex (DUIMP)
**                 
** 
*******************************************************************************/

DEFINE NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR FORMAT "x(12)" NO-UNDO.

/*Tratamento retorno JSON*/
DEFINE VARIABLE oParser          AS ObjectModelParser NO-UNDO. 
DEFINE VARIABLE oJsonArray       AS JsonArray         NO-UNDO.
DEFINE VARIABLE oJsonAgents      AS JsonObject        NO-UNDO.

DEFINE VARIABLE oJsonConstruct   AS JsonConstruct     NO-UNDO.

/*Vari†veis de conex∆o WebService*/
DEFINE VARIABLE iCertifFormat   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCountErros     AS INTEGER    NO-UNDO.
DEFINE variable i               AS INTEGER    NO-UNDO.
DEFINE VARIABLE cCertifFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCertifKeyFile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCertifPassword AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cHost           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRoleType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSetToken       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cXCSRFToken     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNameFileJson   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDirHistorJson  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lAuthenticated  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lHistorEnvio    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE h-bocx00484     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bocx00485     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bocx00480     AS HANDLE     NO-UNDO.
DEFINE VARIABLE mSetToken       AS MEMPTR     NO-UNDO.
DEFINE VARIABLE mXCSRFToken     AS MEMPTR     NO-UNDO.

DEFINE VARIABLE h-accomp        AS HANDLE     NO-UNDO.

{cxbo/bocx00484.i tt-param-siscomex}
{cxbo/bocx00485.i tt-usuar-siscomex}
{cxbo/bocx00480.i tt-item-siscomex}

{method/dbotterr.i} /* RowErrors */

{imp/imapi019.i} /* tt-result, ttHttpRequestHeaders, ttReturnHttpRequest, ttReturnHttpRequestErros */

PROCEDURE authentication:
/*:T------------------------------------------------------------------------------
  Purpose:     MÇtodo que faz a autentiá∆o no portal do siscomex
  Parameters:  
  Notes: O PROGRESS N«O SUPORTA AUTENTICAÄ«O COM CERTIFICADO DO CLIENTE POR ISSO 
        AS REQUISIÄÂES SERÄO FEITAS ATRAVêS DE BIBLIOTECAS DO .NET QUANDO O SISTEMA 
        OPERACIONAL FOR WINDOWS.   
------------------------------------------------------------------------------*/
    
    /*Se n∆o for windows emitir mensagem informando 
    que a DUIMP n∆o Ç suportada para o sistema operacional*/
    IF OPSYS <> "WIN32":U THEN DO:
        {utp/ut-liter.i "com_o_Siscomex"}
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 0,
                                              INPUT 55964,
                                              INPUT RETURN-VALUE).
    END.
    ELSE DO:
        {utp/ut-liter.i "Iniciando_Autenticaá∆o" *}
        RUN setAccompaniment (INPUT RETURN-VALUE).

        RUN authenticationDotNet IN THIS-PROCEDURE.
    END.

    /* Retorna NOK caso exista algum erro na RowErrors */
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        ASSIGN lAuthenticated = NO.
        RETURN "NOK":U.
    END.

    ASSIGN lAuthenticated = YES.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE authenticationDotNet:
/*:T------------------------------------------------------------------------------
  Purpose:    
  Parameters: 
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cEndPoint    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMethod      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cContentType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lcResult     AS LONGCHAR  NO-UNDO.

    ASSIGN cEndPoint    = "portal/api/autenticar":U
           cMethod      = "POST":U.

    RUN getAuthInfo IN THIS-PROCEDURE.

    IF RETURN-VALUE = "OK":U THEN DO:

       EMPTY TEMP-TABLE ttHttpRequestHeaders.
       CREATE ttHttpRequestHeaders.
       ASSIGN ttHttpRequestHeaders.headerName  = "Role-Type":U
              ttHttpRequestHeaders.headerValue = cRoleType.
        
       RUN httpRequest IN THIS-PROCEDURE (INPUT cEndPoint,
                                          INPUT cMethod,
                                          INPUT cContentType,
                                          INPUT "",
                                          INPUT TABLE ttHttpRequestHeaders,
                                          OUTPUT lcResult).

    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getUserSiscomex:
/*:T------------------------------------------------------------------------------
  Purpose: Busca as informaá‰es do usu†rio
---------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bocx00485) THEN DO:
        RUN cxbo/bocx00485.p PERSISTENT SET h-bocx00485.
        RUN openQueryStatic IN h-bocx00485 (INPUT "Main":U) NO-ERROR.
    END.

    RUN goToKey IN h-bocx00485 (INPUT c-seg-usuario).
    RUN getRecord IN h-bocx00485 (OUTPUT TABLE tt-usuar-siscomex).

    FOR FIRST tt-usuar-siscomex NO-LOCK
        WHERE tt-usuar-siscomex.cod-usuar = c-seg-usuario: 
    END.

    IF VALID-HANDLE(h-bocx00485) then do:
        DELETE PROCEDURE h-bocx00485.
        ASSIGN h-bocx00485 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getItemSiscomex:
/*:T------------------------------------------------------------------------------
  Purpose: Busca as informaá‰es do item siscomex
---------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pCodItem AS CHARACTER NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx00480) THEN DO:
        RUN cxbo/bocx00480.p PERSISTENT SET h-bocx00480.
        RUN openQueryStatic IN h-bocx00480 (INPUT "Main":U) NO-ERROR.
    END.

    RUN goToKey IN h-bocx00480 (INPUT pCodItem).
    RUN getRecord IN h-bocx00480 (OUTPUT TABLE tt-item-siscomex).

    FOR FIRST tt-item-siscomex NO-LOCK
        WHERE tt-item-siscomex.cod-item = pCodItem: 
    END.

    IF VALID-HANDLE(h-bocx00480) then do:
        DELETE PROCEDURE h-bocx00480.
        ASSIGN h-bocx00480 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getFieldsUserSiscomex:
/*:T------------------------------------------------------------------------------
  Purpose: Busca a informaá‰es de algum campo espec°fico do usu†rio.
---------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pCnpjCPF AS CHARACTER NO-UNDO.

    RUN getUserSiscomex IN THIS-PROCEDURE.

    IF AVAIL tt-usuar-siscomex THEN DO:
        IF LENGTH(tt-usuar-siscomex.cod-cnpj-cpf) = 14 THEN
            ASSIGN pCnpjCPF = REPLACE(REPLACE(tt-usuar-siscomex.cod-cnpj-cpf, ".",""),"-","").
        ELSE
            IF LENGTH(tt-usuar-siscomex.cod-cnpj-cpf) = 18 THEN
                ASSIGN pCnpjCPF = REPLACE(REPLACE(REPLACE(tt-usuar-siscomex.cod-cnpj-cpf, ".",""),"-",""),"/","")
                       pCnpjCPF = SUBSTRING(pCnpjCPF,1,8).

        IF tt-usuar-siscomex.cod-cnpj-cpf <> "":U AND pCnpjCPF = "":U THEN DO:
            ASSIGN pCnpjCPF = tt-usuar-siscomex.cod-cnpj-cpf.
            {utp/ut-liter.i "Formato_do_campo_CPF/CNPJ_raiz_da_empresa_respons†vel_inv†lido"}
            RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT 55967,
                                                   INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getFieldsItemSiscomex:
/*:T------------------------------------------------------------------------------
  Purpose: Busca a informaá‰es de algum campo espec°fico do item.
---------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pCodItem AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pCnpjCPF AS CHARACTER NO-UNDO.
    
    RUN getItemSiscomex IN THIS-PROCEDURE (INPUT pCodItem).

    IF AVAIL tt-item-siscomex THEN DO:
        ASSIGN pCnpjCPF = REPLACE(REPLACE(REPLACE(tt-item-siscomex.cod-cnpj-cpf, ".",""),"-",""),"/","").
        
        IF LENGTH(pCnpjCPF) = 14 THEN
            ASSIGN pCnpjCPF = SUBSTRING(pCnpjCPF,1,8).
        
        IF tt-item-siscomex.cod-cnpj-cpf <> "":U AND pCnpjCPF = "":U THEN DO:
            ASSIGN pCnpjCPF = tt-item-siscomex.cod-cnpj-cpf.
            {utp/ut-liter.i "Formato_do_campo_CPF/CNPJ_raiz_da_empresa_respons†vel_inv†lido"}
            RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT 55967,
                                                   INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getAuthInfo:
/*:T------------------------------------------------------------------------------
  Purpose: Busca as informaá‰es necess†rias para a autenticaá∆o
------------------------------------------------------------------------------*/
    {utp/ut-liter.i "Buscando_parÉmetros_de_autenticaá∆o" *}
    RUN setAccompaniment (INPUT RETURN-VALUE).

    ASSIGN iCertifFormat   = 0 
           cCertifFile     = "":U
           cCertifKeyFile  = "":U
           cCertifPassword = "":U
           cHost           = "":U
           cRoleType       = "":U
           cRoleType       =  "IMPEXP":U.
           
    IF NOT VALID-HANDLE(h-bocx00484) THEN DO:
        RUN cxbo/bocx00484.p PERSISTENT SET h-bocx00484.
        RUN openQueryStatic IN h-bocx00484 (INPUT "Main":U) NO-ERROR.
    END.

    RUN goToKey IN h-bocx00484 (INPUT 1).
    RUN getRecord IN h-bocx00484 (OUTPUT TABLE tt-param-siscomex).

    FOR FIRST tt-param-siscomex NO-LOCK:

        ASSIGN lHistorEnvio   = tt-param-siscomex.log-histor-envio   
               cDirHistorJson = tt-param-siscomex.cod-dir-histor-xml.
            
        IF tt-param-siscomex.idi-tip-ambiente = 1 THEN /*homologacao*/
            ASSIGN cHost = tt-param-siscomex.cod-url-homol.
        ELSE 
            IF tt-param-siscomex.idi-tip-ambiente = 2 THEN /*producao*/
                ASSIGN cHost = tt-param-siscomex.cod-url-produc.
    END.

    FILE-INFO:FILE-NAME = cDirHistorJson.
    IF lHistorEnvio AND FILE-INFO:FULL-PATHNAME = ? THEN DO:
        {utp/ut-liter.i "O_caminho_especificado_para_salvar_o_hist¢rico_JSON(CD2511)_n∆o_existe"}
        RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                               INPUT 55967,
                                               INPUT RETURN-VALUE).
        RETURN "NOK":U.
    END.    
   
    IF NOT cHost MATCHES "https://*" THEN DO:
            {utp/ut-liter.i "URL_informada_inv†lida"}
            RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT 55967,
                                                   INPUT RETURN-VALUE).
        RETURN "NOK":U.
    END.
    
    RUN getUserSiscomex IN THIS-PROCEDURE.

    IF AVAIL tt-usuar-siscomex THEN
        ASSIGN iCertifFormat   = tt-usuar-siscomex.idi-format-certif-digital /*1 = PEM, 2 = PFX*/
               cCertifFile     = tt-usuar-siscomex.cod-arq-certif                                
               cCertifKeyFile  = STRING(tt-usuar-siscomex.cod-chave-certif)                      
               cCertifPassword = STRING(tt-usuar-siscomex.cod-senha-certif).

    IF VALID-HANDLE(h-bocx00484) then do:
        DELETE PROCEDURE h-bocx00484.
        ASSIGN h-bocx00484 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getReturnHttpRequest:
/*:T------------------------------------------------------------------------------
  Purpose: Retorna temp-table para o programa chamador
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttReturnHttpRequest.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getReturnItemStatus:
/*:T------------------------------------------------------------------------------
  Purpose: Retorna o status individual por item (multiStatus) para o chamador
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttReturnItemStatus.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE executeSending:
/*:T------------------------------------------------------------------------------
  Purpose:     Inicia a chamada para as requisiá‰es
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plcBody         AS LONGCHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER pcEndpoint      AS CHARACTER NO-UNDO.
    define input  parameter pcMethod        as character no-undo.
    DEFINE OUTPUT PARAMETER plHistorEnvio   AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDirHistorJson AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.
    DEFINE OUTPUT PARAMETER plcResult       AS LONGCHAR NO-UNDO. 
    
    DEFINE VARIABLE cEndPoint    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMethod      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cContentType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lcResult     AS LONGCHAR  NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    RUN verificaAuthentication IN THIS-PROCEDURE.

    IF NOT lAuthenticated THEN
        RETURN "NOK":U.
    
    ASSIGN cEndPoint    = pcEndpoint
           cMethod      = pcMethod
           cContentType = "application/json":U.

    EMPTY TEMP-TABLE ttHttpRequestHeaders.
    
    CREATE ttHttpRequestHeaders.
    ASSIGN ttHttpRequestHeaders.headerName  = "Authorization":U
           ttHttpRequestHeaders.headerValue = cSetToken.

    CREATE ttHttpRequestHeaders.
    ASSIGN ttHttpRequestHeaders.headerName  = "X-CSRF-Token":U
           ttHttpRequestHeaders.headerValue = cXCSRFToken.
           
    CREATE ttHttpRequestHeaders.
    ASSIGN ttHttpRequestHeaders.headerName  = "Role-Type":U
           ttHttpRequestHeaders.headerValue = cRoleType.
        
    RUN httpRequest IN THIS-PROCEDURE (INPUT cEndPoint,
                                       INPUT cMethod,
                                       INPUT cContentType,
                                       INPUT plcBody,
                                       INPUT TABLE ttHttpRequestHeaders,
                                       OUTPUT lcResult).
                                       
    ASSIGN plcResult = "".
    FIX-CODEPAGE (plcResult) = 'UTF-8'. 
    
    ASSIGN plcResult = lcResult.
    LOG-MANAGER:WRITE-MESSAGE(">>> response") NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE(">>>" + STRING(lcResult)) NO-ERROR.
    
    run getDataResponse (INPUT lcResult).
                      
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    IF lHistorEnvio AND cDirHistorJson <> "" THEN
        ASSIGN plHistorEnvio   = lHistorEnvio   
               pcDirHistorJson = cDirHistorJson.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE executeSendingMock:
/*:T------------------------------------------------------------------------------
  Purpose:     Inicia a chamada para as requisiá‰es
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plcBody         AS LONGCHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER pcEndpoint      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcMetodo        AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER plHistorEnvio   AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDirHistorJson AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.
    DEFINE OUTPUT PARAMETER plcResult       AS LONGCHAR NO-UNDO.
    
    DEFINE VARIABLE cEndPoint    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMethod      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cContentType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lcResult     AS LONGCHAR  NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    //RUN verificaAuthentication IN THIS-PROCEDURE.
    
    //IF NOT lAuthenticated THEN
    //    RETURN "NOK":U.
    
    ASSIGN cEndPoint    = pcEndpoint
           cMethod      = pcMetodo
           cContentType = "application/json":U.

    EMPTY TEMP-TABLE ttHttpRequestHeaders.
    
/*     CREATE ttHttpRequestHeaders.                                */
/*     ASSIGN ttHttpRequestHeaders.headerName  = "Authorization":U */
/*            ttHttpRequestHeaders.headerValue = cSetToken.        */
/*                                                                 */
/*     CREATE ttHttpRequestHeaders.                                */
/*     ASSIGN ttHttpRequestHeaders.headerName  = "X-CSRF-Token":U  */
/*            ttHttpRequestHeaders.headerValue = cXCSRFToken.      */
        
    RUN httpRequestMock IN THIS-PROCEDURE (INPUT cEndPoint,
                                           INPUT cMethod,
                                           INPUT cContentType,
                                           INPUT plcBody,
                                           INPUT TABLE ttHttpRequestHeaders,
                                           OUTPUT lcResult).
    
    
    ASSIGN plcResult = "".
    FIX-CODEPAGE (plcResult) = 'UTF-8'. 
    
    ASSIGN plcResult = lcResult.
    LOG-MANAGER:WRITE-MESSAGE(">>> response") NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE(">>>" + STRING(lcResult)) NO-ERROR.
    
    RUN getDataResponse(INPUT lcResult).
                      
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    IF lHistorEnvio AND cDirHistorJson <> "" THEN
        ASSIGN plHistorEnvio   = lHistorEnvio   
               pcDirHistorJson = cDirHistorJson.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE httpRequestMock:

    DEFINE INPUT  PARAMETER pcEndPoint      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcMethod        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcContentType   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER plcBody         AS LONGCHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttHttpRequestHeaders.
    DEFINE OUTPUT PARAMETER lcRequestResult AS LONGCHAR  NO-UNDO.
    
    DEFINE VARIABLE newRequest          AS CLASS System.Net.HttpWebRequest                                      NO-UNDO. 
    DEFINE VARIABLE response            AS CLASS System.Net.HttpWebResponse                                     NO-UNDO.
    DEFINE VARIABLE respException       AS CLASS System.Net.HttpWebResponse                                     NO-UNDO.
    DEFINE VARIABLE certificate         AS CLASS System.Security.Cryptography.X509Certificates.X509Certificate2 NO-UNDO.
    DEFINE VARIABLE responseStream      AS CLASS System.IO.Stream                                               NO-UNDO.
    DEFINE VARIABLE streamJson          AS CLASS System.IO.Stream                                               NO-UNDO.
    DEFINE VARIABLE streamReader        AS CLASS System.IO.StreamReader                                         NO-UNDO.
    DEFINE VARIABLE ByteArrayJson       AS "System.Byte[]":U                                                    NO-UNDO.
    DEFINE VARIABLE textEncoding        AS System.Text.Encoding                                                 NO-UNDO.
    DEFINE VARIABLE enumHelper1         AS CLASS System.Enum                                                    NO-UNDO.
    DEFINE VARIABLE enumHelper2         AS CLASS System.Enum                                                    NO-UNDO.
    DEFINE VARIABLE cCertifFileDecode   AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE cPasswordDecode     AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE cContentType        AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE cMsg                AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE lFindResponseErrors AS LOGICAL                                                              NO-UNDO.
    
    /* Security protocols */
    ASSIGN enumHelper1 = Progress.Util.EnumHelper:or ( SecurityProtocolType:Tls, SecurityProtocolType:Tls11 ).
    ASSIGN enumHelper2 = Progress.Util.EnumHelper:or ( CAST ( enumHelper1, SecurityProtocolType ), SecurityProtocolType:Tls12 ).
    ASSIGN ServicePointManager:SecurityProtocol = CAST ( enumHelper2, SecurityProtocolType ).        
        
    {utp/ut-liter.i "Efetuando_a_Integraá∆o" *}
    RUN setAccompaniment (INPUT RETURN-VALUE).
    
    DO ON ERROR UNDO, THROW:

        ASSIGN newRequest = CAST(System.Net.WebRequest:CREATE(pcEndPoint), System.Net.HttpWebRequest)
               newRequest:METHOD = pcMethod.
        IF pcContentType <> "":U THEN
            ASSIGN newRequest:ContentType = pcContentType.
    
        //FOR EACH ttHttpRequestHeaders NO-LOCK:
        //    newRequest:Headers:Add(ttHttpRequestHeaders.headerName, string(ttHttpRequestHeaders.headerValue)).
        //END.
    
/*         /*Converte Certificado PEM para PFX*/                                                                                      */
/*         IF iCertifFormat = 1 AND /*PEM*/                                                                                           */
/*             cCertifFile <> "":U AND                                                                                                */
/*            lc(SUBSTRING(cCertifFile,LENGTH(cCertifFile) - 2,3)) = "pem":U  THEN      /*Certificado ainda n∆o convertido para PFX*/ */
/*             RUN convertPem2Pfx IN THIS-PROCEDURE.                                                                                  */
/*                                                                                                                                    */
/*         /*Decodifica certificado*/                                                                                                 */
/*         IF cCertifFile <> "":U THEN                                                                                                */
/*             ASSIGN cCertifFileDecode = STRING(BASE64-DECODE(cCertifFile)).                                                         */
/*                                                                                                                                    */
/*         /*Decodifica Senha*/                                                                                                       */
/*         IF cCertifPassword <> "":U THEN                                                                                            */
/*             ASSIGN cPasswordDecode = STRING(BASE64-DECODE(cCertifPassword)).                                                       */
/*                                                                                                                                    */
/*         ASSIGN certificate = new X509Certificate2(cCertifFileDecode, cPasswordDecode).                                             */
/*         newRequest:ClientCertificates:Add(certificate).                                                                            */

        /*Envio do Json*/
        IF length(plcBody,"RAW":U) > 0 THEN DO:
            ASSIGN textEncoding             = System.Text.ASCIIEncoding:UTF8  /*Seta encoding*/
                   ByteArrayJson            = textEncoding:GetBytes(plcBody)  /*Transforma JSON para array de bytes*/
                   newRequest:ContentLength = ByteArrayJson:Length            /*Seta tamanho*/
                   streamJSON               = newRequest:GetRequestStream().  /*Seta instancia da requisicao para o stream*/
    
            streamJSON:Write(ByteArrayJson,0,ByteArrayJson:Length). /*Seta Json do corpo da requisicao*/
            streamJSON:Close().
        END.

        ASSIGN response = cast(newRequest:GetResponse(), System.Net.HttpWebResponse).
        
        IF response <> ? THEN DO:
            ASSIGN responseStream   = response:GetResponseStream()
                   streamReader     = NEW System.IO.StreamReader(responseStream)
                   lcRequestResult = streamReader:ReadToEnd().
            
            IF trim(response:StatusCode:ToString()) = "OK":U THEN DO:
/*                 ASSIGN cSetToken   = response:GetResponseHeader("Set-Token":U)                                     */
/*                        cXCSRFToken = response:GetResponseHeader("X-CSRF-Token":U).                                 */
/*                                                                                                                    */
/*                 RUN getUserSiscomex IN THIS-PROCEDURE.                                                             */
/*                                                                                                                    */
/*                 IF AVAIL tt-usuar-siscomex then do:                                                                */
/*                                                                                                                    */
/*                     SET-SIZE (mSetToken)                 = LENGTH(cSetToken) + 1.                                  */
/*                     PUT-STRING(mSetToken, 1)             = cSetToken.                                              */
/*                     ASSIGN tt-usuar-siscomex.cod-livre-1 = BASE64-ENCODE(mSetToken).                               */
/*                     SET-SIZE(mSetToken)                  = 0.                                                      */
/*                                                                                                                    */
/*                     SET-SIZE (mXCSRFToken)                                   = LENGTH(cXCSRFToken) + 1.            */
/*                     PUT-STRING(mXCSRFToken, 1)                               = cXCSRFToken.                        */
/*                     ASSIGN OVERLAY(tt-usuar-siscomex.cod-livre-2, 24, 500)   = STRING(BASE64-ENCODE(mXCSRFToken)). */
/*                     SET-SIZE(mXCSRFToken)                                    = 0.                                  */
/*                                                                                                                    */
/*                     run updateUserSiscomex IN THIS-PROCEDURE.                                                      */
/*                 end.                                                                                               */
            END.
            response:Close(). 
        END.

        /*Trata o retorno da validaá∆o de neg¢cio do portal siscomex*/
        EMPTY TEMP-TABLE ttReturnHttpRequestErros.
                
        /*Trata exceá‰es da biblioteca .Net*/
        CATCH cryptoMsg AS CryptographicException:
            {utp/ut-liter.i "Verifique_se_o_certificado_digital_e_senha_foram_informados_corretamente_para_o_usu†rio"}
            
            RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT 55967,
                                                   INPUT RETURN-VALUE + " ":U + c-seg-usuario).
            RETURN "NOK":U.
        END CATCH.

        CATCH argMsg AS ArgumentException:
            {utp/ut-liter.i "Verifique_se_os_dados_para_a_conex∆o_foram_informados_corretamente_para_o_usu†rio"}
            RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT 55967,
                                                   INPUT RETURN-VALUE + " ":U + c-seg-usuario).
            RETURN "NOK":U.
        END CATCH.

       
        CATCH errorMsg AS WebException:
            ASSIGN respException   = CAST(errorMsg:Response, System.Net.HttpWebResponse)
                   responseStream  = respException:GetResponseStream()
                   streamReader    = NEW System.IO.StreamReader(responseStream)
                   lcRequestResult = streamReader:ReadToEnd() NO-ERROR.
                  
            IF ERROR-STATUS:ERROR THEN DO:
                 {utp/ut-liter.i "Verifique_se_os_dados_para_a_conex∆o_foram_informados_corretamente_para_o_usu†rio*"}
                 ASSIGN lcRequestResult = RETURN-VALUE.
                 RUN createRowErrors IN THIS-PROCEDURE (INPUT 0, 
                                                        INPUT 55967,
                                                        INPUT RETURN-VALUE + " ":U + c-seg-usuario).
            END.
            RETURN "NOK":U.
        END CATCH.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE httpRequest:

    DEFINE INPUT  PARAMETER pcEndPoint      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcMethod        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcContentType   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER plcBody         AS LONGCHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttHttpRequestHeaders.
    DEFINE OUTPUT PARAMETER lcRequestResult AS LONGCHAR  NO-UNDO.
    
    DEFINE VARIABLE newRequest          AS CLASS System.Net.HttpWebRequest                                      NO-UNDO. 
    DEFINE VARIABLE response            AS CLASS System.Net.HttpWebResponse                                     NO-UNDO.
    DEFINE VARIABLE respException       AS CLASS System.Net.HttpWebResponse                                     NO-UNDO.
    DEFINE VARIABLE certificate         AS CLASS System.Security.Cryptography.X509Certificates.X509Certificate2 NO-UNDO.
    DEFINE VARIABLE responseStream      AS CLASS System.IO.Stream                                               NO-UNDO.
    DEFINE VARIABLE streamJson          AS CLASS System.IO.Stream                                               NO-UNDO.
    DEFINE VARIABLE streamReader        AS CLASS System.IO.StreamReader                                         NO-UNDO.
    DEFINE VARIABLE ByteArrayJson       AS "System.Byte[]":U                                                    NO-UNDO.
    DEFINE VARIABLE textEncoding        AS System.Text.Encoding                                                 NO-UNDO.
    DEFINE VARIABLE enumHelper1         AS CLASS System.Enum                                                    NO-UNDO.
    DEFINE VARIABLE enumHelper2         AS CLASS System.Enum                                                    NO-UNDO.
    DEFINE VARIABLE cCertifFileDecode   AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE cPasswordDecode     AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE cContentType        AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE cMsg                AS CHARACTER                                                            NO-UNDO.
    DEFINE VARIABLE lFindResponseErrors AS LOGICAL                                                              NO-UNDO.
    
    IF cHost = "" OR NOT cHost MATCHES "https://*" THEN DO:
        RUN getAuthInfo IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK" THEN RETURN "NOK".
    END.
    
    /* Security protocols */
    ASSIGN enumHelper1 = Progress.Util.EnumHelper:or ( SecurityProtocolType:Tls, SecurityProtocolType:Tls11 ).
    ASSIGN enumHelper2 = Progress.Util.EnumHelper:or ( CAST ( enumHelper1, SecurityProtocolType ), SecurityProtocolType:Tls12 ).
    ASSIGN ServicePointManager:SecurityProtocol = CAST ( enumHelper2, SecurityProtocolType ).        
        
    {utp/ut-liter.i "Efetuando_a_Integraá∆o" *}
    RUN setAccompaniment (INPUT RETURN-VALUE).
    
    DO ON ERROR UNDO, THROW:

        ASSIGN newRequest = CAST(System.Net.WebRequest:CREATE(cHost + "/":U + pcEndPoint), System.Net.HttpWebRequest)
               newRequest:METHOD = pcMethod.
        IF pcContentType <> "":U THEN
            ASSIGN newRequest:ContentType = pcContentType.
    
        FOR EACH ttHttpRequestHeaders NO-LOCK:
            newRequest:Headers:Add(ttHttpRequestHeaders.headerName, string(ttHttpRequestHeaders.headerValue)).
        END.
    
        /*Converte Certificado PEM para PFX*/
        IF iCertifFormat = 1 AND /*PEM*/
            cCertifFile <> "":U AND
           lc(SUBSTRING(cCertifFile,LENGTH(cCertifFile) - 2,3)) = "pem":U  THEN      /*Certificado ainda n∆o convertido para PFX*/            
            RUN convertPem2Pfx IN THIS-PROCEDURE.

        /*Decodifica certificado*/
        IF cCertifFile <> "":U THEN 
            ASSIGN cCertifFileDecode = STRING(BASE64-DECODE(cCertifFile)).
    
        /*Decodifica Senha*/
        IF cCertifPassword <> "":U THEN 
            ASSIGN cPasswordDecode = STRING(BASE64-DECODE(cCertifPassword)).
                
        ASSIGN certificate = new X509Certificate2(cCertifFileDecode, cPasswordDecode).
        newRequest:ClientCertificates:Add(certificate).

        /*Envio do Json*/
        IF length(plcBody,"RAW":U) > 0 THEN DO:
            ASSIGN textEncoding             = System.Text.ASCIIEncoding:UTF8  /*Seta encoding*/
                   ByteArrayJson            = textEncoding:GetBytes(plcBody)  /*Transforma JSON para array de bytes*/
                   newRequest:ContentLength = ByteArrayJson:Length            /*Seta tamanho*/
                   streamJSON               = newRequest:GetRequestStream().  /*Seta instancia da requisicao para o stream*/
    
            streamJSON:Write(ByteArrayJson,0,ByteArrayJson:Length). /*Seta Json do corpo da requisicao*/
            streamJSON:Close().
        END.

        ASSIGN response = cast(newRequest:GetResponse(), System.Net.HttpWebResponse).
        
        IF response <> ? THEN DO:
            ASSIGN responseStream   = response:GetResponseStream()
                   streamReader     = NEW System.IO.StreamReader(responseStream)
                   lcRequestResult  = streamReader:ReadToEnd().

            /* Captura tokens sempre que o servidor os retornar, independente do status */
            ASSIGN cSetToken   = response:GetResponseHeader("Set-Token")
                   cXCSRFToken = response:GetResponseHeader("X-CSRF-Token").

            IF trim(response:StatusCode:ToString()) = "OK" AND
               cSetToken <> "" AND cXCSRFToken <> "" THEN DO:

                RUN getUserSiscomex IN THIS-PROCEDURE.

                IF AVAIL tt-usuar-siscomex THEN DO:
                    DEFINE VARIABLE cDataHora AS CHARACTER NO-UNDO.
                    ASSIGN cDataHora = STRING(NOW).
                    ASSIGN tt-usuar-siscomex.cod-livre-1 = cSetToken
                           tt-usuar-siscomex.cod-livre-2 = cDataHora + "|" + cXCSRFToken.

                    FIND FIRST usuar-siscomex WHERE usuar-siscomex.cod-usuar = tt-usuar-siscomex.cod-usuar EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL usuar-siscomex THEN DO:
                        ASSIGN usuar-siscomex.cod-livre-1 = tt-usuar-siscomex.cod-livre-1
                               usuar-siscomex.cod-livre-2 = tt-usuar-siscomex.cod-livre-2.
                    END.
                END.
            END.

            response:Close(). 
        END.

        /*Trata o retorno da validaá∆o de neg¢cio do portal siscomex*/
        EMPTY TEMP-TABLE ttReturnHttpRequestErros.
                
        /*Trata exceá‰es da biblioteca .Net*/
        CATCH cryptoMsg AS CryptographicException:
            {utp/ut-liter.i "Verifique_se_o_certificado_digital_e_senha_foram_informados_corretamente_para_o_usu†rio"}
            
            RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT 55967,
                                                   INPUT RETURN-VALUE + " ":U + c-seg-usuario).
            RETURN "NOK":U.
        END CATCH.

        CATCH argMsg AS ArgumentException:
            {utp/ut-liter.i "Verifique_se_os_dados_para_a_conex∆o_foram_informados_corretamente_para_o_usu†rio"}
            RUN createRowErrors IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT 55967,
                                                   INPUT RETURN-VALUE + " ":U + c-seg-usuario).
            RETURN "NOK":U.
        END CATCH.

       
        CATCH errorMsg AS WebException:
            ASSIGN respException   = CAST(errorMsg:Response, System.Net.HttpWebResponse)
                   responseStream  = respException:GetResponseStream()
                   streamReader    = NEW System.IO.StreamReader(responseStream)
                   lcRequestResult = streamReader:ReadToEnd() NO-ERROR.
                  
            IF ERROR-STATUS:ERROR THEN DO:
                 {utp/ut-liter.i "Verifique_se_os_dados_para_a_conex∆o_foram_informados_corretamente_para_o_usu†rio*"}
                 ASSIGN lcRequestResult = RETURN-VALUE.
                 RUN createRowErrors IN THIS-PROCEDURE (INPUT 0, 
                                                        INPUT 55967,
                                                        INPUT RETURN-VALUE + " ":U + c-seg-usuario).
            END.
            RETURN "NOK":U.
        END CATCH.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE createCatchErrors:
/*:T------------------------------------------------------------------------------
  Purpose:     Centralizar a criacao de temp-table de erros progress capiturados 
               durante uma execucao 
  Parameters:  eAnyError - objeto capturado
               pType     - indica em qual temp-table atribuir o erro
  Notes: 
----------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER oAnyError AS Progress.Lang.ERROR NO-UNDO.
    DEFINE INPUT PARAMETER pType     AS CHARACTER           NO-UNDO.

    CASE pType:
        WHEN "RowErrors":U THEN DO:

            DO iCountErros = 1 TO oAnyError:NumMessages:
                 CREATE RowErrors.
                 ASSIGN RowErrors.ErrorSequence    = 0
                        RowErrors.ErrorNumber      = oAnyError:GetMessageNum(iCountErros)
                        RowErrors.ErrorType        = "PROGRESS":U
                        RowErrors.ErrorSubType     = "ERROR":U
                        RowErrors.ErrorDescription = PROGRAM-NAME(2) + " - " + oAnyError:GetMessage(iCountErros)
                        RowErrors.ErrorHelp        = PROGRAM-NAME(2) + " - " + oAnyError:GetMessage(iCountErros).
            END.
        END.
        WHEN "ttReturnHttpRequestErros":U THEN DO:

            DO iCountErros = 1 TO oAnyError:NumMessages:
                CREATE ttReturnHttpRequestErros.
                ASSIGN ttReturnHttpRequestErros.erros = PROGRAM-NAME(2) + " - "
                                                      + STRING(oAnyError:GetMessageNum(iCountErros)) 
                                                      + " - ":U 
                                                      + oAnyError:GetMessage(iCountErros).
            END.
        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE createRowErrors:
/*:T------------------------------------------------------------------------------
  Purpose:     Criar registro de erro na temp-table RowErrors
  Parameters:  INPUT pErrorNumber (integer): cΩdigo do erro
               INPUT pParameters (character): par≥metros da mensagem de erro.
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pSeq         AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorNumber AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pParameters  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE vErrorSequence AS INTEGER NO-UNDO.

    ASSIGN vErrorSequence = pSeq.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = vErrorSequence
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorParameters  = pParameters
           RowErrors.ErrorType        = "EMS":U.
     
    RUN utp/ut-msgs.p (INPUT "CodType":U, INPUT pErrorNumber, INPUT "":U).
    CASE INT(RETURN-VALUE):
        WHEN 1 THEN ASSIGN  RowErrors.ErrorSubType = "ERROR":U.
        WHEN 2 THEN ASSIGN  RowErrors.ErrorSubType = "WARNING":U.
        WHEN 3 THEN ASSIGN  RowErrors.ErrorSubType = "QUESTION":U.
        WHEN 4 THEN ASSIGN  RowErrors.ErrorSubType = "INFORMATION":U.
    END CASE.
    
    RUN utp/ut-msgs.p (INPUT "Msg":U, INPUT pErrorNumber, INPUT pParameters).
    ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "Help":U, INPUT pErrorNumber,INPUT pParameters).
    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

    IF TRIM(RowErrors.ErrorDescription) <> TRIM(RowErrors.ErrorHelp) THEN DO:
        ASSIGN RowErrors.ErrorDescription = RowErrors.ErrorDescription. 
    END.

    IF AVAIL RowErrors THEN DO:
        LOG-MANAGER:WRITE-MESSAGE(">>>ERRO Integraá∆o Siscomex: ":U 
                                  + string(RowErrors.ErrorNumber) + ": ":U 
                                  + RowErrors.ErrorDescription    + " - ":U 
                                  + RowErrors.ErrorHelp) NO-ERROR.
    END.

    RETURN "OK":U.
END PROCEDURE.


                                                                                                                                    

PROCEDURE getDataResponse:
    DEFINE INPUT PARAMETER plcJsonResult AS LONGCHAR NO-UNDO.

    DEFINE VARIABLE oJsonObject    AS JsonObject NO-UNDO.
    DEFINE VARIABLE oIdentificacao AS JsonObject NO-UNDO.
    DEFINE VARIABLE oJsonArray     AS JsonArray  NO-UNDO.
    DEFINE VARIABLE oErrorObj      AS JsonObject NO-UNDO.
    DEFINE VARIABLE oItem          AS JsonObject NO-UNDO.
    DEFINE VARIABLE oMultiArray    AS JsonArray  NO-UNDO.
    DEFINE VARIABLE oMultiObj      AS JsonObject NO-UNDO.
    DEFINE VARIABLE oIdentItem     AS JsonObject NO-UNDO.
    DEFINE VARIABLE oErrArray      AS JsonArray  NO-UNDO.
    DEFINE VARIABLE i              AS INTEGER    NO-UNDO.
    DEFINE VARIABLE j              AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lcJsonResponse AS LONGCHAR   NO-UNDO.

    EMPTY TEMP-TABLE ttReturnHttpRequest.
    EMPTY TEMP-TABLE ttReturnItemStatus.

    /* 1. Validaá∆o inicial */
    IF plcJsonResult = "" OR plcJsonResult = ? THEN DO:
        LOG-MANAGER:WRITE-MESSAGE(">>> Retorno do portal - Conte£do vazio.") NO-ERROR.
        RETURN "NOK".
    END.

    FIX-CODEPAGE(lcJsonResponse) = "UTF-8".
    lcJsonResponse = plcJsonResult.

    /* ------------------------------------------------------------------ */
    /* TRATAMENTO EXCLUSIVO PARA JSON ARRAY OBJECT                         */
    /* ------------------------------------------------------------------ */
    RUN parseLongcharToJsonArray(INPUT lcJsonResponse, OUTPUT oJsonArray).

    IF RETURN-VALUE = "OK" THEN DO:

        DO i = 1 TO oJsonArray:Length:
            oItem = oJsonArray:GetJsonObject(i).
            IF NOT VALID-OBJECT(oItem) THEN NEXT.

            CREATE ttReturnHttpRequest.

            /* codigo */
            IF oItem:Has("codigo") THEN
                ttReturnHttpRequest.codigo =
                    IF oItem:GetType("codigo") = JsonDataType:NUMBER
                    THEN STRING(oItem:GetInteger("codigo"))
                    ELSE oItem:GetCharacter("codigo").

            /* versao */
            IF oItem:Has("versao") THEN
                ttReturnHttpRequest.versao = oItem:GetCharacter("versao").

            /* dataReferencia */
            IF oItem:Has("dataReferencia") THEN
                ttReturnHttpRequest.dataReferencia = oItem:GetCharacter("dataReferencia").

            /* cpfCnpjRaiz */ 
            IF oItem:Has("cpfCnpjRaiz") THEN
                ttReturnHttpRequest.cpfCnpjRaiz = oItem:GetCharacter("cpfCnpjRaiz").

            /* codigoInterno / codigosInterno */
            IF oItem:Has("codigoInterno") THEN
                ttReturnHttpRequest.codigoInterno = oItem:GetCharacter("codigoInterno").
            ELSE IF oItem:Has("codigosInterno")
                 AND NOT oItem:IsNull("codigosInterno") THEN DO:

                DEFINE VARIABLE oCodArray AS JsonArray NO-UNDO.

                oCodArray = oItem:GetJsonArray("codigosInterno").

                DO j = 1 TO oCodArray:Length:
                    ttReturnHttpRequest.codigoInterno =
                        ttReturnHttpRequest.codigoInterno
                        + (IF j > 1 THEN "," ELSE "")
                        + oCodArray:GetCharacter(j).
                END.
            END.
        END.

        /* IMPORTANTE:
           Se era array, a l¢gica antiga N«O deve rodar */
        RETURN "OK".
    END.

    /* ------------------------------------------------------------------ */
    /* A PARTIR DAQUI: L‡GICA ORIGINAL (SEM QUALQUER ALTERAÄ«O)            */
    /* ------------------------------------------------------------------ */

    RUN parseLongcharToJsonObjectV2 (INPUT lcJsonResponse, OUTPUT oJsonObject).

    IF RETURN-VALUE = "NOK" OR NOT VALID-OBJECT(oJsonObject) THEN DO:
        LOG-MANAGER:WRITE-MESSAGE(">>> Falha no Parse do JSON.") NO-ERROR.
        RETURN "NOK".
    END.

    DO ON ERROR UNDO, LEAVE:

        CREATE ttReturnHttpRequest.

        IF oJsonObject:Has("identificacao")
           AND NOT oJsonObject:IsNull("identificacao") THEN DO:

            oIdentificacao = oJsonObject:GetJsonObject("identificacao").

            IF oIdentificacao:Has("numero") THEN
                ttReturnHttpRequest.numero =
                    oIdentificacao:GetCharacter("numero").

            IF oIdentificacao:Has("versao") THEN
                ttReturnHttpRequest.versao =
                    oIdentificacao:GetCharacter("versao").
        END.
        ELSE DO:
            IF oJsonObject:Has("codigo") THEN DO:
                IF oJsonObject:GetType("codigo") = JsonDataType:NUMBER THEN
                    ttReturnHttpRequest.codigo =
                        STRING(oJsonObject:GetInteger("codigo")).
                ELSE
                    ttReturnHttpRequest.codigo =
                        oJsonObject:GetCharacter("codigo").
            END.

            IF oJsonObject:Has("versao") THEN
                ttReturnHttpRequest.versao =
                    oJsonObject:GetCharacter("versao").

            IF oJsonObject:Has("seq") THEN
                ttReturnHttpRequest.seq =
                    STRING(oJsonObject:GetInteger("seq")).

            IF oJsonObject:Has("cpfCnpjRaiz") THEN
                ttReturnHttpRequest.cpfCnpjRaiz =
                    oJsonObject:GetCharacter("cpfCnpjRaiz").

            IF oJsonObject:Has("codigoInterno") THEN
                ttReturnHttpRequest.codigoOperadorEstrangeiro =
                    oJsonObject:GetCharacter("codigoInterno").

            IF oJsonObject:Has("dataReferencia") THEN
                ttReturnHttpRequest.dataReferencia =
                    oJsonObject:GetCharacter("dataReferencia").

            IF oJsonObject:Has("message") THEN
                ttReturnHttpRequest.mensagem =
                    oJsonObject:GetCharacter("message").
        END.

        /* Tratamento de erros */
        IF oJsonObject:Has("errors")
           AND NOT oJsonObject:IsNull("errors") THEN DO:

            oJsonArray = oJsonObject:GetJsonArray("errors").

            DO i = 1 TO oJsonArray:Length:
                oErrorObj = oJsonArray:GetJsonObject(i).

                IF VALID-OBJECT(oErrorObj) THEN DO:
                    CREATE ttReturnHttpRequest.

                    IF oErrorObj:Has("code") THEN
                        ttReturnHttpRequest.codigo =
                            oErrorObj:GetCharacter("code").

                    IF oErrorObj:Has("message") THEN
                        ttReturnHttpRequest.mensagem =
                            oErrorObj:GetCharacter("message").
                END.
            END.
        END.

        /* Tratamento do multiStatus (status individual por item) */
        IF oJsonObject:Has("multiStatus")
           AND NOT oJsonObject:IsNull("multiStatus") THEN DO:

            oMultiArray = oJsonObject:GetJsonArray("multiStatus").

            DO i = 1 TO oMultiArray:Length:
                oMultiObj = oMultiArray:GetJsonObject(i).
                IF NOT VALID-OBJECT(oMultiObj) THEN NEXT.

                CREATE ttReturnItemStatus.

                IF oMultiObj:Has("code") THEN
                    ttReturnItemStatus.code = oMultiObj:GetInteger("code") NO-ERROR.

                IF oMultiObj:Has("identificacao")
                   AND NOT oMultiObj:IsNull("identificacao") THEN DO:
                    oIdentItem = oMultiObj:GetJsonObject("identificacao").
                    IF oIdentItem:Has("numeroItem") THEN
                        ttReturnItemStatus.numeroItem =
                            INTEGER(oIdentItem:GetCharacter("numeroItem")) NO-ERROR.
                END.

                /* code fora da faixa 2xx (200-299) => item com erro */
                ttReturnItemStatus.comErro =
                    (ttReturnItemStatus.code < 200 OR ttReturnItemStatus.code > 299).

                /* Mensagem do item: usa "message" e concatena errors[].message */
                IF oMultiObj:Has("message") THEN
                    ttReturnItemStatus.mensagem = oMultiObj:GetCharacter("message").

                IF oMultiObj:Has("errors")
                   AND NOT oMultiObj:IsNull("errors") THEN DO:
                    oErrArray = oMultiObj:GetJsonArray("errors").
                    DO j = 1 TO oErrArray:Length:
                        oErrorObj = oErrArray:GetJsonObject(j).
                        IF VALID-OBJECT(oErrorObj) AND oErrorObj:Has("message") THEN
                            ttReturnItemStatus.mensagem =
                                ttReturnItemStatus.mensagem
                                + (IF ttReturnItemStatus.mensagem <> "" THEN " | " ELSE "")
                                + oErrorObj:GetCharacter("message").
                    END.
                END.
            END.
        END.

        RETURN "OK".

        CATCH e AS Progress.Lang.Error:
            LOG-MANAGER:WRITE-MESSAGE(
                ">>> Erro no processamento: " + e:GetMessage(1)) NO-ERROR.
            RUN createCatchErrors(INPUT e, INPUT "RowErrors").
            RETURN "NOK".
        END CATCH.
    END.

    FINALLY:
        IF VALID-OBJECT(oJsonObject) THEN DELETE OBJECT oJsonObject.
        IF VALID-OBJECT(oJsonArray)  THEN DELETE OBJECT oJsonArray.
    END.

END PROCEDURE.

PROCEDURE getErrorResponse:
/*:T------------------------------------------------------------------------------
  Purpose:     Percorre o longchar do response para encontrar erro
  Parameters:  plcJsonResult - longchar com o json
               plFindErros   - retorna yes quando encontra algum erro
  Notes: Modelo esperado de retorno siscomex:
         [{"seq": 1, "codigo": "string", "erros": ["string"], "sucesso": false}]
----------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plcJsonResult AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER plFindErros   AS LOGICAL  NO-UNDO.
    
    DEFINE VARIABLE lSucesso AS LOGICAL NO-UNDO.
    DEFINE VARIABLE oJsonArrayErros  AS JsonArray         NO-UNDO.
            
    IF plcJsonResult = "" THEN
        RETURN "OK":U.
    
    RUN parseLongcharToJsonArray(INPUT plcJsonResult, OUTPUT oJsonArray). //Cria oJsonArray

    IF RETURN-VALUE = "NOK":U THEN //plcJsonResult nao Ç um jsonArray
        RETURN "OK":U.
    
    //Percorre o array de retorno
    DO iCount = 1 TO oJsonArray:LENGTH:
        
        oJsonAgents = oJsonArray:GetJsonObject(iCount).

        ASSIGN lSucesso = LOGICAL(JsonAPIUtils:getPropertyJsonObject(oJsonAgents,"sucesso":U)).

        IF NOT lSucesso THEN DO:

            oJsonArrayErros = oJsonAgents:GetJsonArray("erros":U).

            //Percorre o array de erros
            DO iCountErros = 1 TO oJsonArrayErros:LENGTH:
            
                CREATE ttReturnHttpRequestErros.
    
                IF oJsonAgents:has("seq":U) THEN  
                    ASSIGN ttReturnHttpRequestErros.seq = STRING(oJsonAgents:getJsonText("seq":U)).
                           
                ASSIGN ttReturnHttpRequestErros.erros = oJsonArrayErros:GetCharacter(iCountErros)
                       plFindErros                    = YES.
            END.
        END.
    END.
    
    RETURN "OK":U.

    CATCH eAnyError AS Progress.Lang.Error:
        RUN createCatchErrors(INPUT eAnyError, INPUT "ttReturnHttpRequestErros":U).
        ASSIGN plFindErros = YES.
        RETURN "NOK":U.
    END CATCH.
END PROCEDURE.

PROCEDURE parseLongcharToJsonArray:
/*:T------------------------------------------------------------------------------
  Purpose:     Centralizar a maneira de converter um longchar para o objeto oJsonArray da api.
  Parameters:  plcJsonResult - longchar com o json
  Notes: 
----------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER plcJsonResult AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER plcJsonArray AS JsonArray NO-UNDO.

    DEFINE VARIABLE lcJsonResult AS LONGCHAR  NO-UNDO.

    FIX-CODEPAGE (lcJsonResult) = 'UTF-8':U.

    ASSIGN lcJsonResult = plcJsonResult.

    oParser        = NEW ObjectModelParser().
    oJsonConstruct = oParser:Parse(lcJsonResult) NO-ERROR.

    IF JsonAPIUtils:checkJsonIsArray(oJsonConstruct) THEN
        plcJsonArray = CAST(oParser:Parse(lcJsonResult), JsonArray).
    ELSE
        RETURN "NOK":U.

    RETURN "OK":U.

    CATCH eAnyError AS Progress.Lang.Error:
        RUN createCatchErrors(INPUT eAnyError, INPUT "RowErrors":U).
        RETURN "NOK":U.
    END CATCH.
END PROCEDURE.

PROCEDURE parseLongcharToJsonObjectV2:
    DEFINE INPUT  PARAMETER plcJsonResult AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER poJsonObject  AS JsonObject NO-UNDO.

    DEFINE VARIABLE oParser        AS ObjectModelParser NO-UNDO.
    DEFINE VARIABLE oJsonConstruct AS JsonConstruct     NO-UNDO.

    /* 1. Instanciamos o Parser fora do bloco de erro para garantir o controle */
    oParser = NEW ObjectModelParser().

    /* 2. Bloco de execuá∆o */
    DO ON ERROR UNDO, LEAVE:
        
        oJsonConstruct = oParser:Parse(plcJsonResult).

        IF TYPE-OF(oJsonConstruct, JsonObject) THEN
            poJsonObject = CAST(oJsonConstruct, JsonObject).
        ELSE
            RETURN "NOK":U.

        /* Se chegou atÇ aqui sem erros e Ç um objeto, retorna OK */
        RETURN "OK":U.

        /* 3. Captura erros de Parse (ex: JSON mal formatado) */
        CATCH e AS Progress.Lang.Error:
            RETURN "NOK":U.
        END CATCH.
        
        /* 4. O FINALLY dentro do DO garante a limpeza se o Parse falhar ou der RETURN */
        FINALLY:
            IF VALID-OBJECT(oParser) THEN DELETE OBJECT oParser.
        END FINALLY.
        
    END. /* Fim do DO */

    RETURN "NOK":U.

END PROCEDURE.

PROCEDURE convertPem2Pfx:
/*:T------------------------------------------------------------------------------
  Purpose:     Converte o certificado no formato PEM para PFX.
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cComand         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cProgressInst   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPasswordDecode AS CHARACTER   NO-UNDO.

     /*Decodifica Senha*/
    IF cCertifPassword <> "":U THEN DO:
        ASSIGN cPasswordDecode = STRING(BASE64-DECODE(cCertifPassword)).
    END.

    /*Busca local de instalaªío do Progress*/
    GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE cProgressInst.

    /*Monta linha de comando para conversío via SSLC*/
    ASSIGN cComand = cProgressInst + '\bin\sslc pkcs12 -in "':U + cCertifFile + '" -inkey "':U + cCertifKeyFile + 
                    '" -password pass:':U + cPasswordDecode + ' -passin pass:':U + cPasswordDecode + 
                    ' -passout pass:':U + cPasswordDecode + ' -export -out "':U + STRING(SESSION:TEMP-DIRECTORY + 'certificate.pfx"':U).
  
    /*Executa linha de comando*/
    OS-COMMAND SILENT VALUE(cComand).
    
    /*Verifica se arquivo PFX foi gerado corretamente.*/
    FILE-INFO:FILE-NAME = STRING(SESSION:TEMP-DIRECTORY + "certificate.pfx":U).

    IF FILE-INFO:FILE-SIZE > 0 THEN DO:
        ASSIGN cCertifFile = SESSION:TEMP-DIRECTORY + "certificate.pfx":U.
    END.
    ELSE DO:
        ASSIGN cCertifFile = "":U.
        /*Erro na conversío do certificado*/
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 0,
                                              INPUT 55966,
                                              INPUT "":U).
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE setAccompaniment :
/*------------------------------------------------------------------------------
  Purpose:      Seta informaá∆o apresentada no acompanhamento
  Parameters:   pc-accomp-content: Entrada - Conte£do a ser apresentado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-accomp-content AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-accomp) AND pc-accomp-content <> "":U THEN 
         RUN pi-acompanhar IN h-accomp (INPUT pc-accomp-content).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE setAccompHandle :
/*------------------------------------------------------------------------------
  Purpose:      Seta o handle da tela de acompanhamento
  Parameters:   ph-accomp: Entrada - Handle da tela de acompanhamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER ph-accomp AS HANDLE NO-UNDO.

    ASSIGN h-accomp = ph-accomp.

    RETURN "OK":U.
END PROCEDURE.

procedure updateUserSiscomex:
/*:T------------------------------------------------------------------------------
  Purpose: Atualiza as informaá‰es do usu†rio
---------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bocx00485) THEN DO:
        RUN cxbo/bocx00485.p PERSISTENT SET h-bocx00485.
        RUN openQueryStatic in h-bocx00485 (INPUT "Main":U).
    END.
    
    RUN goToKey            IN h-bocx00485(INPUT tt-usuar-siscomex.cod-usuar).
            
    IF RETURN-VALUE = "OK":U THEN DO:
        LOG-MANAGER:WRITE-MESSAGE(">>> IMAPI019 - Atualiza TOKEN") NO-ERROR.
        RUN setRecord    IN h-bocx00485 (INPUT TABLE tt-usuar-siscomex).
        RUN updateRecord IN h-bocx00485.
    END.
            
    RUN getRowErrors in h-bocx00485 (OUTPUT TABLE RowErrors).

    IF VALID-HANDLE(h-bocx00485) THEN DO:
        DELETE PROCEDURE h-bocx00485.
        ASSIGN h-bocx00485 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE verificaAuthentication:
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se o usu†rio ja tem token autenticado ou se precisa autenticar novamente
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dtToken             AS DATETIME  NO-UNDO.
    DEFINE VARIABLE dtAgora             AS DATETIME  NO-UNDO.
    DEFINE VARIABLE cDataHora           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCSRF               AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lUsuarioAutenticado AS LOGICAL   NO-UNDO INIT NO.

    RUN getUserSiscomex IN THIS-PROCEDURE.
       
    IF AVAIL tt-usuar-siscomex THEN DO:

        IF NUM-ENTRIES(tt-usuar-siscomex.cod-livre-2, "|":U) < 2 THEN DO:
            ASSIGN tt-usuar-siscomex.cod-livre-1 = ""
                   tt-usuar-siscomex.cod-livre-2 = "".
        END.
        
        ASSIGN 
            cDataHora = entry(1, tt-usuar-siscomex.cod-livre-2, "|":U)
            dtAgora   = NOW.

        /* ? valida existància */
        IF tt-usuar-siscomex.cod-livre-1 <> "" AND cDataHora <> "" THEN DO:

            IF NUM-ENTRIES(cDataHora, " ") >= 2 THEN DO:

                dtToken = DATETIME(cDataHora).

                /* ? valida tempo corretamente */
                if ((dtAgora - dtToken) < 60000) THEN DO:

                    LOG-MANAGER:WRITE-MESSAGE(">>> Token v†lido - reutilizando") NO-ERROR.

                    assign 
                        cSetToken   = TRIM(tt-usuar-siscomex.cod-livre-1)
                        cXCSRFToken = TRIM(entry(2, tt-usuar-siscomex.cod-livre-2, "|":U ))
                        lUsuarioAutenticado = YES
                        lAuthenticated      = YES.

                    RETURN "OK".
                END.
            END.
        END.
        
        IF NOT lUsuarioAutenticado THEN DO:
        
            LOG-MANAGER:WRITE-MESSAGE(">>>> IMAPI019 - Usuario nao possui token valido") NO-ERROR.
            RUN authentication IN THIS-PROCEDURE.
            IF NOT lAuthenticated THEN
                RETURN "NOK":U.

            /* S¢ persiste se os tokens foram realmente obtidos */
            IF TRIM(cSetToken) = "" OR TRIM(cXCSRFToken) = "" THEN DO:
                LOG-MANAGER:WRITE-MESSAGE(">>> ERRO: Tokens vazios apos autenticacao.") NO-ERROR.
                ASSIGN lAuthenticated = NO.
                RETURN "NOK".
            END.

            ASSIGN 
                cDataHora = STRING(NOW)
                cCSRF     = TRIM(cXCSRFToken).

            ASSIGN
                tt-usuar-siscomex.cod-livre-1 = TRIM(cSetToken)
                tt-usuar-siscomex.cod-livre-2 = cDataHora + "|" + cCSRF.

            FIND FIRST usuar-siscomex 
                WHERE usuar-siscomex.cod-usuar = tt-usuar-siscomex.cod-usuar 
                EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL usuar-siscomex THEN DO:
                ASSIGN 
                    usuar-siscomex.cod-livre-1 = tt-usuar-siscomex.cod-livre-1
                    usuar-siscomex.cod-livre-2 = tt-usuar-siscomex.cod-livre-2.
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.

/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT060A 2.00.00.001}  /*** "010001" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEFT060A MFT}
&ENDIF
 

/*------------------------------------------------------------------------

  File: ANEFT060A.P

  Description: Gerador XML do ANEFT060.P - Envio de informa‡äes de 
               cr‚dito ao CRM

  Input Parameters:  <none>
  
  Output Parameters: <none>

  Author: Odil B. Neto (log13165)

  Created: 04/03/2003

------------------------------------------------------------------------*/
/*           This .W file was NOT created with AppBuilder.              */
/*----------------------------------------------------------------------*/

DEF INPUT PARAM rw-estabelec     AS ROWID.
DEF INPUT PARAM rw-emitente      AS ROWID.
DEF INPUT PARAM de-saldo-ap      AS DECIMAL.
DEF INPUT PARAM de-saldo-cr      AS DECIMAL.
DEF INPUT PARAM de-vl-nota       AS DECIMAL.
DEF INPUT PARAM de-totvlap       AS DECIMAL.
DEF INPUT PARAM de-saldo-credito AS DECIMAL.

DEF VAR c-root               AS CHAR NO-UNDO.
DEF VAR c-message            AS CHAR NO-UNDO.
DEF VAR c-campo              AS CHAR NO-UNDO.
DEF VAR c-FromRole           AS CHAR NO-UNDO.
DEF VAR c-ToRole             AS CHAR NO-UNDO.
DEF VAR c-CreditInformationCollection AS CHAR NO-UNDO.
DEF VAR c-CreditInformation           AS CHAR NO-UNDO.


&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

/* Emitente */
IF rw-emitente <> ? THEN
    FOR FIRST emitente WHERE
              ROWID(emitente) = rw-emitente NO-LOCK.
IF NOT AVAIL emitente THEN DO:
    RETURN "NOK":U.
    
END.

/* Estabelecimento / Empresa */
IF rw-estabelec <> ? THEN
    FOR FIRST estabelec WHERE
              ROWID(estabelec) = rw-estabelec NO-LOCK:
       FOR FIRST empresa WHERE
                 empresa.ep-codigo = estabelec.ep-codigo NO-LOCK.
       END.
    END.
IF NOT AVAIL estabelec THEN DO:
    RETURN "NOK":U.        
END.

RUN pi-cabecalho-msg.
RUN pi-corpo-msg.
RUN pi-rodape-msg.

WRITExml().

END.

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("CreditInformationCollections","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-CreditInformationCollection = AddElement(c-message,"CreditInformationCollection")
                 c-CreditInformation = AddElement(c-CreditInformationCollection,"CreditInformation")
               c-FromRole = AddElement(c-message,"FromRole")
               c-ToRole = AddElement(c-message,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-campo = AddEleInt(c-CreditInformation,"InternalCode", emitente.cod-emitente)
           c-campo = AddEleChar(c-CreditInformation,"ShortName", emitente.nome-abrev)
           c-campo = AddEleChar(c-CreditInformation,"LegalName", emitente.nome-emit).

    RUN pi-identificationCollection-msg.

    ASSIGN c-campo = AddEleDeci(c-CreditInformation, "CreditLimit", emitente.lim-credito)
           c-campo = AddEleDate(c-CreditInformation, "CreditLimitDate", emitente.dt-lim-cred, "")
           c-campo = AddEleDeci(c-CreditInformation, "AdditionalCreditLimit", emitente.lim-adicional)
           c-campo = AddEleDate(c-CreditInformation, "AdditionalCreditLimitDate", emitente.dt-fim-cred, "")
           c-campo = AddEleDeci(c-CreditInformation, "PayableAccountsBalance", de-saldo-ap)
           c-campo = AddEleDeci(c-CreditInformation, "ReceivableAccountsBalance", de-saldo-cr)
           c-campo = AddEleDeci(c-CreditInformation, "InvoicesNotUpdatedAR", de-vl-nota)
           c-campo = AddEleDeci(c-CreditInformation, "ApprovedEvaluatedOrdersTotal", de-totvlap)
           c-campo = AddEleDeci(c-CreditInformation, "CurrentBalance", de-saldo-credito).
END PROCEDURE.

PROCEDURE pi-identificationCollection-msg:
DEF VAR c-IdentificationCollection AS CHAR NO-UNDO.
DEF VAR c-Identification           AS CHAR NO-UNDO.

    ASSIGN c-IdentificationCollection = addElement(c-CreditInformation, "IdentificationCollection")
              c-Identification = addElement (c-IdentificationCollection, "Identification")
                 c-campo = addEleChar(c-IdentificationCollection, "IdentificationType", (IF emitente.natureza = 2 THEN "CNPJ" else "CPF"))
                 c-campo = addEleChar(c-IdentificationCollection, "IdentificationNumber", emitente.cgc).
                    
END PROCEDURE .

PROCEDURE pi-rodape-msg:
    DEF VAR c-Address AS CHAR NO-UNDO.

    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier","")
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-Address = AddElement(c-FromRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1",empresa.endereco) 
             c-campo = AddEleChar(c-Address,"AddressLine2",empresa.endereco-2) 
             c-campo = AddEleChar(c-Address,"AddressLine3","") 
             c-campo = AddEleChar(c-Address,"CityName",empresa.cidade) 
             c-campo = AddEleChar(c-Address,"DistrictName",empresa.bairro) 
             c-campo = AddEleChar(c-Address,"StateCode",empresa.uf) 
             c-campo = AddEleChar(c-Address,"LegacyCountryCode",empresa.pais) 
             c-campo = AddEleChar(c-Address,"NationalPostalCode",empresa.cep).
    
    ASSIGN c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier","")
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","")
           c-Address = AddElement(c-ToRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1","") 
             c-campo = AddEleChar(c-Address,"AddressLine2","") 
             c-campo = AddEleChar(c-Address,"AddressLine3","") 
             c-campo = AddEleChar(c-Address,"CityName","") 
             c-campo = AddEleChar(c-Address,"DistrictName","") 
             c-campo = AddEleChar(c-Address,"StateCode","") 
             c-campo = AddEleChar(c-Address,"LegacyCountryCode","") 
             c-campo = AddEleChar(c-Address,"NationalPostalCode","").
             
END PROCEDURE.

&ENDIF


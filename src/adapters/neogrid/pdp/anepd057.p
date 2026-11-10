/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD057 2.00.00.001} /*** "010001" 06/11/2024 14:04:19  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD057 MPD}
&ENDIF


/******************************************************************************
**  Programa: anepd057.p 
**  Funcao  : Sender de Transportadores
**  Data    : 09/2002
**  Autor   : 
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */


DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root               AS CHAR NO-UNDO.
DEF VAR c-message            AS CHAR NO-UNDO.
DEF VAR c-campo              AS CHAR NO-UNDO.
DEF VAR c-FromRole           AS CHAR NO-UNDO.
DEF VAR c-ToRole             AS CHAR NO-UNDO.
DEF VAR c-UpdatePartner      AS CHAR NO-UNDO.
DEF VAR c-PartnerCollection  AS CHAR NO-UNDO.
DEF VAR c-PartnerInformation AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND transporte WHERE ROWID(transporte) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL transporte THEN
        RUN   pi-corpo-msg.
END.
ELSE
    FOR EACH transporte NO-LOCK:
        RUN  pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root                       = CreateNeoGridDoc("UpdatePartners","1.01.001","1")
             c-message                  = AddElement(c-root,"CRM")
             c-message                  = AddElement(c-root,"Message")
               c-UpdatePartner          = AddElement(c-message,"UpdatePartner")
                 c-PartnerCollection    = AddElement(c-UpdatePartner,"PartnerCollection")
                 c-FromRole             = AddElement(c-UpdatePartner,"FromRole")
                 c-ToRole               = AddElement(c-UpdatePartner,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN
    c-PartnerInformation = AddElement(c-PartnerCollection,"PartnerInformation").
    RUN pi-EstablishmentInformation-msg.
    RUN pi-EstablishmentRoles-msg.
    RUN pi-IdentificationCollection-msg.
    RUN pi-AddressCollection-msg.
    RUN pi-ContactCollection-msg.
END PROCEDURE.
                                                                                            
PROCEDURE pi-EstablishmentInformation-msg:

    DEF VAR c-EstablishmentInformation  AS CHAR NO-UNDO.
    DEF VAR c-Individual                AS CHAR NO-UNDO.

    ASSIGN c-EstablishmentInformation = AddElement(c-PartnerInformation,"EstablishmentInformation")
             c-campo                  = AddEleInt(c-EstablishmentInformation,"InternalCode",transporte.cod-transp) 
             c-campo                  = AddEleChar(c-EstablishmentInformation,"ShortName",transporte.nome-abrev)   
             c-campo                  = AddEleChar(c-EstablishmentInformation,"LegalName",transporte.nome)   
             c-campo                  = AddEleChar(c-EstablishmentInformation,"URL",transporte.home-page)   
             c-campo                  = AddEleChar(c-EstablishmentInformation,"Fax",transporte.telefax)   
             c-campo                  = AddEleChar(c-EstablishmentInformation,"E-mail",transporte.e-mail)   
             c-campo                  = AddEleChar(c-EstablishmentInformation,"Telephone",transporte.telefone)   
             c-campo                  = AddEleChar(c-EstablishmentInformation,"Ramal",transporte.ramal)
             c-Individual             = AddElement(c-EstablishmentInformation,"Individual")
               c-campo                = AddEleChar(c-Individual,"Birthday","")   
               c-campo                = AddEleChar(c-Individual,"MotherName","")   
               c-campo                = AddEleChar(c-Individual,"FatherName","")   
             c-campo                  = AddEleChar(c-EstablishmentInformation,"CustomerGroup","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"MarketActivity","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"Representative","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"MicroTerritory","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"Carrier","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"RegisterDate","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"CreditIndicator","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"PaymentTerm","")
             c-campo                  = AddEleChar(c-EstablishmentInformation,"Comments","").
END PROCEDURE.

PROCEDURE pi-EstablishmentRoles-msg:
    
    DEF VAR c-EstablishmentRoles AS CHAR NO-UNDO.
    
    ASSIGN c-EstablishmentRoles = AddElement(c-PartnerInformation,"EstablishmentRoles")
             c-campo            = AddEleChar(c-EstablishmentRoles,"Portal","FALSE") 
             c-campo            = AddEleChar(c-EstablishmentRoles,"Carrier","TRUE")   
             c-campo            = AddEleChar(c-EstablishmentRoles,"Customer","FALSE")   
             c-campo            = AddEleChar(c-EstablishmentRoles,"Supplier","FALSE")   
             c-campo            = AddEleChar(c-EstablishmentRoles,"PurchaseCentral","FALSE")   
             c-campo            = AddEleChar(c-EstablishmentRoles,"Distributor","FALSE")   
             c-campo            = AddEleChar(c-EstablishmentRoles,"Establishment","FALSE").

END PROCEDURE.

PROCEDURE pi-IdentificationCollection-msg:

    DEF VAR c-IdentificationCollection  AS CHAR NO-UNDO.
    DEF VAR c-Identification            AS CHAR NO-UNDO.
    
    ASSIGN c-IdentificationCollection   = AddElement(c-PartnerInformation,"IdentificationCollection")
             c-Identification           = AddElement(c-IdentificationCollection,"Identification")     
               c-campo                  = AddEleChar(c-Identification,"IdentificationType",IF transporte.natureza = 1 THEN "CPF" ELSE "CNPJ")
               c-campo                  = AddEleChar(c-Identification,"IdentificationNumber",transporte.cgc) 
               c-campo                  = AddEleChar(c-Identification,"EmmitingAgency","").
             IF transporte.ins-estadual <> "" THEN
             ASSIGN   
             c-Identification           = AddElement(c-IdentificationCollection,"Identification")     
               c-campo                  = AddEleChar(c-Identification,"IdentificationType","IE") 
               c-campo                  = AddEleChar(c-Identification,"IdentificationNumber",transporte.ins-estadual)
               c-campo                  = AddEleChar(c-Identification,"EmmitingAgency","").

END PROCEDURE.

PROCEDURE pi-AddressCollection-msg:
    
    DEF VAR c-AddressCollection         AS CHAR NO-UNDO.
    DEF VAR c-IdentificationCollection  AS CHAR NO-UNDO.
    DEF VAR c-Identification            AS CHAR NO-UNDO.
    DEF VAR c-Address                   AS CHAR NO-UNDO.

    ASSIGN 
           c-AddressCollection              = AddElement(c-PartnerInformation,"AddressCollection")
             c-Address                      = AddElement(c-AddressCollection,"Address")     
               c-campo                      = AddEleInt(c-Address,"AddressType",8) 
               c-campo                      = AddEleChar(c-Address,"AddressLine1",transporte.endereco) 
               c-campo                      = AddEleChar(c-Address,"AddressLine2","") 
               c-campo                      = AddEleChar(c-Address,"AddressLine3","") 
               c-campo                      = AddEleChar(c-Address,"CityName",transporte.cidade) 
               c-campo                      = AddEleChar(c-Address,"DistrictName",transporte.bairro) 
               c-campo                      = AddEleChar(c-Address,"StateCode",transporte.estado) 
               c-campo                      = AddEleChar(c-Address,"LegacyCountryCode",transporte.pais) 
               c-campo                      = AddEleChar(c-Address,"NationalPostalCode",transporte.cep) 
               c-campo                      = AddEleChar(c-Address,"RegionName","") 
               c-campo                      = AddEleChar(c-Address,"AddressCode","").
               ASSIGN 
               c-IdentificationCollection   = AddElement(c-Address,"IdentificationCollection")
                 c-Identification           = AddElement(c-IdentificationCollection,"Identification")     
                   c-campo                  = AddEleChar(c-Identification,"IdentificationType",IF transporte.natureza = 1 THEN "CPF" ELSE "CNPJ")
                   c-campo                  = AddEleChar(c-Identification,"IdentificationNumber",transporte.cgc) 
                   c-campo                  = AddEleChar(c-Identification,"EmmitingAgency","").
                 IF transporte.ins-estadual <> "" THEN /* Mandar apenas se existir */
                 ASSIGN 
                 c-Identification           = AddElement(c-IdentificationCollection,"Identification") 
                   c-campo                  = AddEleChar(c-Identification,"IdentificationType","IE") 
                   c-campo                  = AddEleChar(c-Identification,"IdentificationNumber",transporte.ins-estadual) 
                   c-campo                  = AddEleChar(c-Identification,"EmmitingAgency","").

END PROCEDURE.

PROCEDURE pi-ContactCollection-msg:
    
    DEF VAR c-ContactCollection  AS CHAR NO-UNDO.
    DEF VAR c-ContactInformation AS CHAR NO-UNDO.

    FOR EACH cont-tran NO-LOCK
       WHERE cont-tran.cod-transp     = transporte.cod-transp:

        ASSIGN 
               c-ContactCollection    = AddElement(c-PartnerInformation,"ContactCollection")
                 c-ContactInformation = AddElement(c-ContactCollection,"ContactInformation")     
                   c-campo            = AddEleChar(c-ContactInformation,"ContactName",cont-tran.nome) 
                   c-campo            = AddEleChar(c-ContactInformation,"TelephoneNumber",cont-tran.telefone)
                   c-campo            = AddEleChar(c-ContactInformation,"EmailAddress",transporte.e-mail) 
                   c-campo            = AddEleChar(c-ContactInformation,"Fax",cont-tran.telefax) 
                   c-campo            = AddEleChar(c-ContactInformation,"Ramal",cont-tran.ramal).
    END.
END PROCEDURE.


PROCEDURE pi-rodape-msg:
    
    DEFINE VAR c-Address            AS CHAR NO-UNDO.
    DEFINE VAR c-ContactInformation AS CHAR NO-UNDO.

    FIND FIRST estabelec WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        FIND FIRST empresa WHERE empresa.ep-codigo = estabelec.ep-codigo NO-LOCK NO-ERROR.
    /* FromRole */
    ASSIGN  c-campo              = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
            c-campo              = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
            c-ContactInformation = AddElement(c-FromRole,"ContactInformation")             
              c-campo            = AddEleChar(c-ContactInformation,"ContactName","")
              c-campo            = AddEleChar(c-ContactInformation,"TelephoneNumber","")
              c-campo            = AddEleChar(c-ContactInformation,"EmailAddress","")
            c-Address            = AddElement(c-FromRole,"Address")
              c-campo            = AddEleChar(c-Address,"AddressLine1",empresa.endereco) 
              c-campo            = AddEleChar(c-Address,"AddressLine2",empresa.endereco-2) 
              c-campo            = AddEleChar(c-Address,"AddressLine3","") 
              c-campo            = AddEleChar(c-Address,"CityName",empresa.cidade) 
              c-campo            = AddEleChar(c-Address,"DistrictName",empresa.bairro) 
              c-campo            = AddEleChar(c-Address,"StateCode",empresa.uf) 
              c-campo            = AddEleChar(c-Address,"LegacyCountryCode",empresa.pais) 
              c-campo            = AddEleChar(c-Address,"NationalPostalCode",empresa.cep) 
              c-campo            = AddEleChar(c-Address,"RegionName","") 
              c-campo            = AddEleChar(c-Address,"AddressCode","")
              c-campo            = AddEleChar(c-Address,"EmailAddress",""). 
    /* ToRole */
    ASSIGN  c-campo              = AddEleChar(c-ToRole,"LegacyLocationIdentifier","")
            c-campo              = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","")
            c-ContactInformation = AddElement(c-ToRole,"ContactInformation")
              c-campo            = AddEleChar(c-ContactInformation,"ContactName","")
              c-campo            = AddEleChar(c-ContactInformation,"TelephoneNumber","")
              c-campo            = AddEleChar(c-ContactInformation,"EmailAddress","")
            c-Address            = AddElement(c-ToRole,"Address")
              c-campo            = AddEleChar(c-Address,"AddressLine1","")
              c-campo            = AddEleChar(c-Address,"AddressLine2","")
              c-campo            = AddEleChar(c-Address,"AddressLine3","")
              c-campo            = AddEleChar(c-Address,"CityName","")
              c-campo            = AddEleChar(c-Address,"DistrictName","")
              c-campo            = AddEleChar(c-Address,"StateCode","")
              c-campo            = AddEleChar(c-Address,"LegacyCountryCode","")
              c-campo            = AddEleChar(c-Address,"NationalPostalCode","")
              c-campo            = AddEleChar(c-Address,"RegionName","")
              c-campo            = AddEleChar(c-Address,"AddressCode","").
END PROCEDURE.

&ENDIF

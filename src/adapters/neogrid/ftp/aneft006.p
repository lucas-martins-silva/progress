/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT006 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft006 MAN}
&ENDIF

/******************************************************************************
**  Programa: aneft006.p
**  Funcao  : Sender da Via de transporte
**  Data    : 06/2002
**  Autor   : Anderson Silvano
**  Versao  :
**  I.00.000 - Anderson Silvano
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
    
{adapters/neogrid/include/anein004.i} /* sender */

DEF VAR c-root                      AS CHAR NO-UNDO. 
DEF VAR c-message                   AS CHAR NO-UNDO.
DEF VAR c-ShippingMethodCollection  AS CHAR NO-UNDO.
DEF VAR c-campo                     AS CHAR NO-UNDO.
DEF VAR c-UpdateShippingMethod      AS CHAR NO-UNDO.
DEF VAR c-ShippingMethodInformation AS CHAR NO-UNDO.
DEF VAR c-FromRole                  AS CHAR NO-UNDO.
DEF VAR c-ToRole                    AS CHAR NO-UNDO.


ASSIGN c-root = CreateNeoGridDoc("UpdateShippingMethod","1.01.001","1")
       c-message = AddElement(c-root,"Message")
       c-UpdateShippingMethod = AddElement(c-message,"UpdateShippingMethod")
       c-ShippingMethodCollection = AddElement(c-UpdateShippingMethod,"ShippingMethodCollection")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",1)
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","Rodovi rio")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",2)
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","A‚reo")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",3)           
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","Mar¡timo")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",4)
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","Ferrovi rio")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",5)
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","Rodoferrovi rio")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",6)
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","Rodofluvial")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",7)
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","Rodoaereovi rio")
       c-ShippingMethodInformation = AddElement(c-ShippingMethodCollection,"ShippingMethodInformation")
       c-campo = AddEleInt(c-ShippingMethodInformation,"LegacyShippingMethodCode",8)
       c-campo = AddEleChar(c-ShippingMethodInformation,"ShippingMethodDescription","Outros")
       c-FromRole = AddElement(c-UpdateShippingMethod,"FromRole")
       c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
       c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
       c-ToRole = AddElement(c-UpdateShippingMethod,"ToRole")
       c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",c-cod-estabel)
       c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
    WRITExml().

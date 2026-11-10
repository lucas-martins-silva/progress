/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD095 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd095 MAN}
&ENDIF

/********************************************************************************
** Programa : anepd095.p
** Fun‡Æo   : Sender da rela‡Æo item x cliente
** Data     : 06/2005
** Autor    : Lutz Carlos Gunhter
********************************************************************************/
{adapters/neogrid/include/anein004.i}
DEF INPUT PARAM r-rowid             AS ROWID   NO-UNDO.
DEF INPUT PARAM l-remove            AS LOGICAL NO-UNDO. 

DEF VAR c-root                      AS CHAR NO-UNDO. 
DEF VAR c-message                   AS CHAR NO-UNDO.
DEF VAR c-productmapping            AS CHAR NO-UNDO.
DEF VAR c-productmappingcollection  AS CHAR NO-UNDO.
DEF VAR c-productmappingitem        AS CHAR NO-UNDO.
DEF VAR c-campo                     AS CHAR NO-UNDO.
DEF VAR c-fromrole                  AS CHAR NO-UNDO.
DEF VAR c-torole                    AS CHAR NO-UNDO.

{cdp/cdcfgdis.i}

RUN SendSupplierProductRelation.

PROCEDURE SendSupplierProductRelation:
    FIND item-cli 
        WHERE ROWID(item-cli) = r-rowid NO-LOCK NO-ERROR.
    
    IF AVAIL item-cli THEN DO:
        FIND ITEM 
            WHERE ITEM.it-codigo = item-cli.it-codigo NO-LOCK NO-ERROR.
        
        IF  AVAIL ITEM THEN DO:
            &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
            FOR FIRST emitente FIELDS (cod-emitente)
                WHERE emitente.cod-emitente = item-cli.cod-emitente
                AND   SUBSTR(emitente.char-1,11,1) = "1" NO-LOCK:
            &ELSE
            FOR FIRST emitente FIELDS (cod-emitente) NO-LOCK
                WHERE emitente.cod-emitente = item-cli.cod-emitente,
                FIRST dist-emitente FIELDS (cod-emitente)
                WHERE dist-emitente.cod-emitente = emitente.cod-emitente
                AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
            &ENDIF
                
                FIND FIRST para-ped NO-LOCK NO-ERROR.                  
                FOR FIRST  estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = para-ped.estab-padrao:
                        RUN custBuildSupplierProductRelation.
                        WriteXML().
                END.
            END.
        END.
    END.
END.

PROCEDURE custBuildSupplierProductRelation:
    DEFINE VARIABLE EAN-13 AS CHARACTER  NO-UNDO.

    ASSIGN c-root = CreateNeoGridDoc("ProductMapping","1.01.001",estabelec.cod-estabel)                                  
           c-message = AddElement(c-root,"Message")                                                                             
           c-productmapping = AddElement(c-message,"ProductMapping")                                                          
           c-productmappingcollection = AddElement(c-productmapping,"ProductMappingCollection")                             
           c-productmappingitem = AddElement(c-productmappingcollection,"ProductMappingInformation")                                 
           c-campo = AddEleChar(c-productmappingitem,"OwnerInternalProductCode",item-cli.it-codigo)                     
           c-campo = AddEleChar(c-productmappingitem,"MyUnitOfMeasure",item.un)                                         
           c-campo = AddEleChar(c-productmappingitem,"ProductDescription",item.desc-item)          
           c-campo = AddEleChar(c-productmappingitem,"PartnerInternalProductCode", IF EAN-13 <> "" THEN EAN-13 ELSE item-cli.item-do-cli)                 
           c-campo = AddEleChar(c-productmappingitem,"PartnerUnitOfMeasure",item-cli.unid-med-cli)                      
           c-campo = ADDELEDeci(c-productmappingitem,"ConversionFactor",item-cli.fator-conversao)                           
           c-campo = AddEleInt(c-productmappingitem,"DecimalsNumber",item-cli.num-casa-dec)                             
           c-campo = AddEleChar(c-productmappingitem,"SendInventory","false")                                           
           c-campo = AddEleChar(c-productmappingitem,"Remove","false")                                                  
           c-campo = AddEleChar(c-productmappingitem,"Comment",item-cli.Narrativa).

    assign c-fromrole = AddElement(c-productmapping,"FromRole")
           c-campo  = AddEleChar(c-fromrole,"LegacyLocationIdentifier",estabelec.cod-estabel)
           c-campo  = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-torole = AddElement(c-productmapping,"ToRole")
           c-campo  = AddEleInt(c-torole,"LegacyLocationIdentifier",item-cli.cod-emitente)
           c-campo  = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

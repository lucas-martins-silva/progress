/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEEN056 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEEN056 MEN}
&ENDIF


/******************************************************************************
**  Programa: aneen056.p
**  Funcao  : Sender da Unidade de Medida
**  Data    : 04/2007
**  Autor   : Anderson Luiz Rodrigues Silvano
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root                    AS CHAR NO-UNDO. 
DEF VAR c-message                 AS CHAR NO-UNDO.
DEF VAR c-UnitOfMeasureCollection AS CHAR NO-UNDO.
DEF VAR c-UOMInformation          AS CHAR NO-UNDO.
DEF VAR c-UOMConversionCollection AS CHAR NO-UNDO.
DEF VAR c-UOMConversion           AS CHAR NO-UNDO.
DEF VAR c-campo                   AS CHAR NO-UNDO.
DEF VAR c-UpdateUnitOfMeasure     AS CHAR NO-UNDO.
DEF VAR c-FromUOM                 AS CHAR NO-UNDO.
DEF VAR c-ToUOM                   AS CHAR NO-UNDO.
DEF VAR c-FromRole                AS CHAR NO-UNDO.
DEF VAR c-ToRole                  AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND tab-conv-un WHERE ROWID(tab-conv-un) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL tab-conv-un THEN DO:
        FIND tab-unidade WHERE tab-unidade.un = tab-conv-un.un NO-LOCK NO-ERROR.
        IF AVAIL tab-unidade THEN DO:  
            RUN pi-corpo-tab-un.
            RUN pi-corpo-tab-conv.
        END.
    END.
END.
ELSE DO:
    FOR EACH tab-unidade NO-LOCK:
        RUN pi-corpo-tab-un.
    END.
    FOR EACH tab-conv-un NO-LOCK:
        RUN pi-corpo-tab-conv.
    END.
END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root                           = CreateNeoGridDoc("UpdateUnitOfMeasure","1.01.001","1")
             c-message                      = AddElement(c-root,"CRM")
             c-message                      = AddElement(c-root,"Message")
               c-UpdateUnitOfMeasure        = AddElement(c-message,"UpdateUnitOfMeasure")
                 c-UnitOfMeasureCollection  = AddElement(c-UpdateUnitOfMeasure,"UnitOfMeasureCollection")
                 c-UOMConversionCollection  = AddElement(c-UpdateUnitOfMeasure,"UOMConversionCollection")
                 c-FromRole                 = AddElement(c-UpdateUnitOfMeasure,"FromRole")
                 c-ToRole                   = AddElement(c-UpdateUnitOfMeasure,"ToRole").
        
END PROCEDURE.

PROCEDURE pi-corpo-tab-un:
   
    ASSIGN c-UOMInformation = AddElement(c-UnitOfMeasureCollection,"UOMInformation")
             c-campo        = AddElechar(c-UOMInformation,"UnitOfMeasureID",tab-unidade.un)
             c-campo        = AddElechar(c-UOMInformation,"UOMDescription",tab-unidade.descricao). 
        
END PROCEDURE.

PROCEDURE pi-corpo-tab-conv:
    ASSIGN c-UOMConversion = AddElement(c-UOMConversionCollection,"UOMConversion")  
             c-FromUOM     = AddElement(c-UOMConversion,"FromUOM")
               c-campo     = AddElechar(c-FromUOM,"UnitOfMeasureID",tab-conv-un.un)
             c-ToUOM       = AddElement(c-UOMConversion,"ToUOM")
               c-campo     = AddElechar(c-ToUOM,"UnitOfMeasureID",tab-conv-un.unid-med-for)
               c-campo     = AddEleInt(c-ToUOM,"ConversionFactor",tab-conv-un.fator-conver)
               c-campo     = AddEleInt(c-ToUOM,"DecimalsNumber",tab-conv-un.num-casa-dec). 
        
END.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo   = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo   = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                      THEN STRING(i-cod-emitente)
                                                                      ELSE "")
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF



/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD034 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD034 MPD}
&ENDIF

/******************************************************************************
**  Programa: anepd034.p
**  Funcao  : Sender Unidade Negocio x Item
**  Data    : 03/2008
**  Autor   : M rcio Lohmann
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
DEF VAR c-ProductBusinessUnitColl AS CHAR NO-UNDO.
DEF VAR c-ProductBusinessUnitInfo AS CHAR NO-UNDO.
DEF VAR c-campo                   AS CHAR NO-UNDO.
DEF VAR c-ProductBusinessUnit     AS CHAR NO-UNDO.
DEF VAR c-FromRole                AS CHAR NO-UNDO.
DEF VAR c-ToRole                  AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND FIRST ITEM WHERE ROWID(ITEM) = p-rowid NO-LOCK NO-ERROR.
    FOR EACH  unid-neg-item NO-LOCK
        WHERE unid-neg-item.it-codigo = ITEM.it-codigo:
        RUN pi-corpo.
    END.
END.
ELSE DO:
    FOR EACH unid-neg-item NO-LOCK:
        RUN pi-corpo.
    END.
END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root                          = CreateNeoGridDoc("ProductBusinessUnit","1.01.001","1")
             c-message                     = AddElement(c-root,"CRM")
             c-message                     = AddElement(c-root,"Message")
               c-ProductBusinessUnit       = AddElement(c-message,"ProductBusinessUnit")
                 c-ProductBusinessUnitColl = AddElement(c-ProductBusinessUnit,"ProductBusinessUnitCollection")
                 c-FromRole                = AddElement(c-ProductBusinessUnit,"FromRole")
                 c-ToRole                  = AddElement(c-ProductBusinessUnit,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo:
   
    ASSIGN c-ProductBusinessUnitInfo = AddElement(c-ProductBusinessUnitColl,"ProductBusinessUnitInformation")
           c-campo                   = AddEleChar(c-ProductBusinessUnitInfo,"ProductCode"         , unid-neg-item.it-codigo)
           c-campo                   = AddEleChar(c-ProductBusinessUnitInfo,"BusinessUnitCode"    , unid-neg-item.cod_unid_negoc)
           c-campo                   = AddEleDeci(c-ProductBusinessUnitInfo,"BusinessUnitPercent" , unid-neg-item.perc-unid-neg).
        
END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo   = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo   = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo   = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                      THEN STRING(i-cod-emitente)
                                                                      ELSE "")
           c-campo   = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF

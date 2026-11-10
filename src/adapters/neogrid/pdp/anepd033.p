/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD033 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD033 MPD}
&ENDIF

/******************************************************************************
**  Programa: anepd033.p
**  Funcao  : Sender Unidade Negocio x Familia Comercial
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

DEF VAR c-root                          AS CHAR NO-UNDO. 
DEF VAR c-message                       AS CHAR NO-UNDO.
DEF VAR c-ProductFamilyBusinessUnitColl AS CHAR NO-UNDO.
DEF VAR c-ProductFamilyBusinessUnitInfo AS CHAR NO-UNDO.
DEF VAR c-campo                         AS CHAR NO-UNDO.
DEF VAR c-ProductFamilyBusinessUnit     AS CHAR NO-UNDO.
DEF VAR c-FromRole                      AS CHAR NO-UNDO.
DEF VAR c-ToRole                        AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND unid-neg-fam-com WHERE ROWID(unid-neg-fam-com) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL unid-neg-fam-com THEN DO:
        RUN pi-corpo.
    END.
END.
ELSE DO:
    FOR EACH unid-neg-fam-com NO-LOCK:
        RUN pi-corpo.
    END.
END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root                                = CreateNeoGridDoc("ProductFamilyBusinessUnit","1.01.001","1")
             c-message                           = AddElement(c-root,"CRM")
             c-message                           = AddElement(c-root,"Message")
               c-ProductFamilyBusinessUnit       = AddElement(c-message,"ProductFamilyBusinessUnit")
                 c-ProductFamilyBusinessUnitColl = AddElement(c-ProductFamilyBusinessUnit,"ProductFamilyBusinessUnitCollection")
                 c-FromRole                      = AddElement(c-ProductFamilyBusinessUnit,"FromRole")
                 c-ToRole                        = AddElement(c-ProductFamilyBusinessUnit,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo:
   
    ASSIGN c-ProductFamilyBusinessUnitInfo = AddElement(c-ProductFamilyBusinessUnitColl,"ProductFamilyBusinessUnitInformation")
           c-campo                         = AddEleChar(c-ProductFamilyBusinessUnitInfo,"FamilyCode"          , unid-neg-fam-com.fm-codigo)
           c-campo                         = AddEleChar(c-ProductFamilyBusinessUnitInfo,"BusinessUnitCode"    , unid-neg-fam-com.cod_unid_negoc)
           c-campo                         = AddEleDeci(c-ProductFamilyBusinessUnitInfo,"BusinessUnitPercent" , unid-neg-fam-com.perc-unid-neg). 
        
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

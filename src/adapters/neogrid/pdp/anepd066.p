/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD066 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD066 MPD}
&ENDIF


/********************************************************************************
** Programa : aneft065.p
** Fun»’o   : Sender de Estrutura Comercial
** Data     : 12/2007
** Autor    : Marcelo Bittencourt
********************************************************************************/

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root                          AS CHAR. 
DEF VAR c-message                       AS CHAR.
DEF VAR c-campo                         AS CHAR.
DEF VAR c-CommercialProduct             AS CHAR.
DEF VAR c-CommercialProductCollection   AS CHAR.
DEF VAR c-CommercialProductInformation  AS CHAR.
DEF VAR c-ItemCollection                AS CHAR.
DEF VAR c-ItemInformation               AS CHAR.
DEF VAR c-FromRole                      AS CHAR NO-UNDO.
DEF VAR c-ToRole                        AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

FOR EACH produto-coml NO-LOCK:

    RUN pi-corpo-msg.

    ASSIGN c-ItemCollection = AddElement(c-CommercialProductInformation,"ItemCollection":U).

    FOR EACH est-prod-coml OF produto-coml NO-LOCK:
        RUN pi-detalhe-msg.
    END.

END.

RUN pi-rodape-msg.

WRITExml().

RETURN "OK":U.

/* PROCEDURES */
PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("CommercialProduct":U,"1.01.001":U,"1":U)
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message":U)
               c-CommercialProduct = AddElement(c-message,"CommercialProduct":U)
                 c-CommercialProductCollection = AddElement(c-CommercialProduct,"CommercialProductCollection":U)
                 c-FromRole = AddElement(c-CommercialProduct,"FromRole":U)
                 c-ToRole = AddElement(c-CommercialProduct,"ToRole":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-CommercialProductInformation = AddElement(c-CommercialProductCollection,"CommercialProductInformation":U)
             c-campo = AddEleChar(c-CommercialProductInformation,"CommercialProductCode":U,Produto-coml.cod-produto-coml)
             c-campo = AddEleChar(c-CommercialProductInformation,"CommercialProductName":U,Produto-coml.des-produto-coml)
             c-campo = AddEleChar(c-CommercialProductInformation,"Description":U,          Produto-coml.des-narrativa)
             c-campo = AddEleChar(c-CommercialProductInformation,"Inactive":U,             IF Produto-coml.log-obsoleto THEN "True" ELSE "False").

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-detalhe-msg:
    ASSIGN c-ItemInformation = AddElement(c-ItemCollection,"ItemInformation":U)
             c-campo = AddEleChar(c-ItemInformation,"ItemIdentifier":U,Est-prod-coml.it-codigo)
             c-campo = AddEleDeci(c-ItemInformation,"Quantity":U,      Est-prod-coml.qt-aplicada)
             c-campo = AddEleDeci(c-ItemInformation,"Proportion":U,    Est-prod-coml.proporcao)
             c-campo = AddEleDate(c-ItemInformation,"InitialDate":U,   Est-prod-coml.dat-inic-validade,"")
             c-campo = AddEleDate(c-ItemInformation,"FinalDate":U,     Est-prod-coml.dat-fim-validade,"").

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo   = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
             c-campo   = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                        THEN STRING(i-cod-emitente)
                                                                        ELSE "")
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF


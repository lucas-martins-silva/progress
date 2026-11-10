/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD030 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd030 MAN}
&ENDIF

/******************************************************************************
**  Programa: anepd030.p
**  Funcao  : Sender do Portador
**  Data    : 03/2008
**  Autor   : Otaner Marcelo Demarchi
******************************************************************************/
{cdp/cdcfgdis.i} /* Pre-processadores Distribuicao */

DEF INPUT PARAMETER c-portador-row  AS ROWID    NO-UNDO.

DEF VAR c-root                 AS CHAR NO-UNDO. 
DEF VAR c-message              AS CHAR NO-UNDO.
DEF VAR c-portador             AS CHAR NO-UNDO.
DEF VAR c-portador-collection  AS CHAR NO-UNDO.
DEF VAR c-campo                AS CHAR NO-UNDO.

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF c-portador-row <> ? THEN DO:
    FIND FIRST portador WHERE ROWID(portador) = c-portador-row NO-LOCK NO-ERROR.
        RUN pi-corpo-portador.
END.
ELSE DO:
    FOR EACH portador NO-LOCK:
        RUN pi-corpo-portador.
    END.
 END.

WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdateCollector","1.01.001","1")
           c-message = AddElement(c-root,"CRM")
           c-message = AddElement(c-root,"Message")
           c-portador-collection = AddElement(c-message,"CollectorCollection").
END PROCEDURE.

PROCEDURE pi-corpo-portador:
    ASSIGN c-portador = AddElement(c-portador-collection,"Collector")
        c-campo = &IF '{&bf_dis_versao_ems}':U >= '2.071':U &THEN AddEleChar(c-portador, "CompanyCode", portador.ep-codigo) &ELSE AddEleInt(c-portador, "CompanyCode", portador.ep-codigo) &ENDIF
        c-campo = AddEleInt(c-portador, "CollectorCode", portador.cod-portador)
        c-campo = AddEleInt(c-portador, "CollectorMode", portador.modalidade)
        c-campo = AddEleChar(c-portador, "Name", portador.nome)
        c-campo = AddEleInt(c-portador, "Banco", portador.cod-banco)
        c-campo = AddEleChar(c-portador, "Agencia", portador.agencia)
        c-campo = AddEleChar(c-portador, "ContaCorrente", portador.conta-corren)
        c-campo = AddEleChar(c-portador, "Carteira", portador.cod-carteira)
        c-campo = AddEleDeci(c-portador, "ValorSaldo", portador.valor-saldo)
        c-campo = AddEleDeci(c-portador, "ValorSaldoIni", portador.vl-saldo-ini)
        c-campo = AddEleChar(c-portador, "ExigeAceite", if portador.exige-aceite
                                                        then "Sim"
                                                        else "NÆo").
END PROCEDURE.

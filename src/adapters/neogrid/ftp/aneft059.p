/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT059 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEFT059 MFT}
&ENDIF


/******************************************************************************
**  Programa: aneft059.p 
**  Funcao  : Sender de Tipos de Receita/Despesa
**  Data    : 10/2002
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

DEF VAR c-root                          AS CHAR NO-UNDO. 
DEF VAR c-message                       AS CHAR NO-UNDO.
DEF VAR c-UpdateExpenseIncomeTypes      AS CHAR NO-UNDO.
DEF VAR c-ExpenseIncomeTypesCollection  AS CHAR NO-UNDO.
DEF VAR c-ExpenseIncomeTypesInformation AS CHAR NO-UNDO.
DEF VAR c-campo                         AS CHAR NO-UNDO.
DEF VAR c-FromRole                      AS CHAR NO-UNDO.
DEF VAR c-ToRole                        AS CHAR NO-UNDO.

&IF int(entry(1,proversion,".")) >= 8 &THEN

{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  p-rowid <> ? THEN DO:
    FIND tipo-rec-desp WHERE ROWID(tipo-rec-desp) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL tipo-rec-desp THEN
        RUN pi-corpo-msg.
END.
ELSE
    FOR EACH tipo-rec-desp NO-LOCK:
        RUN pi-corpo-msg.
    END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdateExpenseIncomeTypes","1.01.001","1")
             c-message = AddElement(c-root,"CRM")
             c-message = AddElement(c-root,"Message")
               c-UpdateExpenseIncomeTypes = AddElement(c-message,"UpdateExpenseIncomeTypes")
                 c-ExpenseIncomeTypesCollection = AddElement(c-UpdateExpenseIncomeTypes,"ExpenseIncomeTypesCollection")
                 c-FromRole = AddElement(c-UpdateExpenseIncomeTypes,"FromRole")
                 c-ToRole = AddElement(c-UpdateExpenseIncomeTypes,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-ExpenseIncomeTypesInformation = AddElement(c-ExpenseIncomeTypesCollection,"ExpenseIncomeTypesInformation")
             c-campo = AddEleInt(c-ExpenseIncomeTypesInformation,"ExpenseIncomeTypesCode",tipo-rec-desp.tp-codigo)
             c-campo = AddEleChar(c-ExpenseIncomeTypesInformation,"ExpenseIncomeTypesType",ENTRY(tipo-rec-desp.tipo,{adinc/i01ad259.i 03}))
             c-campo = AddEleChar(c-ExpenseIncomeTypesInformation,"ExpenseIncomeTypesDescription",descricao).
END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",IF  i-cod-emitente <> 0
                                                                    THEN STRING(i-cod-emitente)
                                                                    ELSE "")
             c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.

&ENDIF



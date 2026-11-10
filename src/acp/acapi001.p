/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ACAPI001 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ACAPI001 MUT}
&ENDIF



/********************************************************************************
** Programa : acp/acapi001.p
**
** Data : 29/07/98
**
** Autor : Datasul S.A.
**
** Objetivo  : API que retorna x coluna e n linha do Microsoft Excel 97 para PROGRESS.
**
** Versoes: Eder Carlos Querino - Planner - Cria‡Æo - 29/07/1998
********************************************************************************/

{acp/acapi001.i}

def input  param table for tt-configuracao.
def output param table for tt-dados.
def output param table for tt-erros.

def var ch-Excel    as office.iface.excel.ExcelWrapper no-undo.
def var ch-Arquivo  as office.iface.excel.Workbook no-undo.
def var ch-Planilha as office.iface.excel.WorkSheet no-undo.

def var c-arquivo   as char             no-undo.
def var i-planilha  as int              no-undo.
def var i-coluna    as int              no-undo.
def var i-linha     as int              no-undo.

find first tt-configuracao no-error.

assign tt-configuracao.arquivo = replace(tt-configuracao.arquivo, "~/", "~\").

if avail tt-configuracao then do:
  if tt-configuracao.versao-integracao <> 1 then do:
    run utp/ut-msgs.p (input "msg", input 3941, input "").    
    create tt-erros.
    assign tt-erros.codigo-erro = 3941
           tt-erros.descricao = return-value.
    return "NOK".       
  end.
end.
else do:
  run utp/ut-msgs.p (input "msg", input 8646, input "").    
  create tt-erros.
  assign tt-erros.codigo-erro = 3941
         tt-erros.descricao = return-value.
  return "NOK".       
end.

{office/office.i Excel ch-Excel}

assign c-arquivo  = tt-configuracao.arquivo
       i-planilha = tt-configuracao.planilha.
       
if VALID-OBJECT(ch-Arquivo) then 
   ch-Arquivo:Close().

if search(c-arquivo) <> ? then  
   ch-Arquivo = ch-Excel:Workbooks:Open(c-arquivo,?,yes).
else do:
   run utp/ut-msgs.p (input "msg", 
                      input 1926, 
                      input "").
   create tt-erros.
   assign tt-erros.codigo-erro = 1926
          tt-erros.descricao = return-value.
   return "NOK".
end.  


ch-Planilha = ch-Arquivo:WorkSheets:Item(i-planilha).
ch-Planilha:Activate().

assign i-linha = tt-configuracao.linha-inicio.

repeat :

  do i-coluna = tt-configuracao.coluna-inicio to tt-configuracao.coluna-final:
     create tt-dados.
     assign tt-dados.planilha      = i-planilha
            tt-dados.celula-linha  = i-linha
            tt-dados.celula-coluna = i-coluna
            tt-dados.valor         = ch-Excel:Cells(i-linha,i-coluna):Text.
     if i-coluna = tt-configuracao.coluna-inicio and tt-dados.valor = "" then
        leave.
            
  end. /*fim do "do" */
  
  assign i-linha = i-linha + 1.       
  
  if i-coluna = tt-configuracao.coluna-inicio 
      AND tt-dados.valor = "" THEN DO:
        leave.
  END.
     
end. /*fim do repeat*/

ch-Arquivo:Close().
ch-Excel:Quit().

if VALID-OBJECT(ch-Planilha) then
  DELETE object ch-Planilha.
if VALID-OBJECT(ch-Arquivo) then
  DELETE object ch-Arquivo.
if VALID-OBJECT(ch-Excel) then
  DELETE object ch-Excel.

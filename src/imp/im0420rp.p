/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0420RP 2.00.00.015 } /*** 010015 ***/
/*****************************************************************************
**
**       PROGRAMA: ESPD1006
**
**       DATA....: AGOSTO DE 2007
**
**       Objetivo: Relat¢rio de Acompanhamento das Informa‡äes
**
**       VERSAO..: 2.00.001 - Roger Rayner
**
******************************************************************************/
/*{utp/ut-glob.i}*/
{cdp/cdcfgmat.i}
{include/i-rpvar.i}

/***************************Defini‡Æo de Parƒmetros *****************************/

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD usuario   LIKE param-re.usuario
    FIELD destino   AS INT  
    FIELD data-exec AS DATE 
    FIELD hora-exec AS INT 
    FIELD arquivo   AS CHAR. 

DEF TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
    field r-Rowid as ROWID.

DEFINE TEMP-TABLE tt-erro-relat NO-UNDO
    FIELD msg-erro AS CHARACTER FORMAT "X(300)".

DEF TEMP-TABLE tt-editor NO-UNDO
    FIELD linha      AS INTEGER
    FIELD conteudo   AS CHARACTER FORMAT 'X(80)'
    INDEX editor-id IS PRIMARY UNIQUE 
          linha.

DEFINE VARIABLE h-acomp    AS HANDLE                    NO-UNDO.
DEFINE VARIABLE c-mensagem AS CHARACTER FORMAT "X(50)"  NO-UNDO.
DEFINE VARIABLE c-erro     LIKE tt-erro-relat.msg-erro  NO-UNDO.
DEFINE VARIABLE c-linha    AS CHARACTER FORMAT "X(132)" NO-UNDO.


DEF INPUT PARAM TABLE FOR tt-decla-import.
DEF INPUT PARAM TABLE FOR tt-param.
DEF INPUT PARAM TABLE FOR tt-erro-relat.

FORM
   tt-decla-import.num-di-ems COLUMN-LABEL 'DI EMS'   AT 1
   tt-decla-import.cod-estab  COLUMN-LABEL 'Estab.'   AT 17
   c-mensagem                 COLUMN-LABEL 'Mensagem' AT 31
   WITH DOWN WIDTH 132 STREAM-IO FRAME f-geradas.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-geradas:HANDLE).


FORM HEADER SKIP(2) 
     "Aten‡Æo!" AT 001 SKIP
     c-linha
    WITH WIDTH 132 NO-LABEL NO-BOX STREAM-IO FRAME f-cabecErro.

RUN utp/ut-acomp PERSISTENT SET h-acomp.      
RUN pi-inicializar IN h-acomp ('Imprimindo'). 

/****************************** L i t e r a i s **********************************/

/* {utp/ut-liter.i SELE€ÇO * R}                                                      */
/* assign c-selecao = trim(return-value).                                            */
/*                                                                                   */
/* {utp/ut-liter.i IMPRESSÇO * R}                                                    */
/* assign c-impressao = trim(return-value).                                          */
/*                                                                                   */
/* {utp/ut-liter.i CLASSIFICA€ÇO * R}                                                */
/* assign c-classifica = trim(return-value).                                         */
/*                                                                                   */
/* {utp/ut-liter.i Destino * L}                                                      */
/* assign c-destino:label in frame f-parametros = trim(return-value).                */
/*                                                                                   */
/* {utp/ut-liter.i Usu rio * L}                                                      */
/* assign tt-param.usuario:label in frame f-parametros = trim(return-value).         */
/*                                                                                   */
/* {utp/ut-liter.i Classifica‡Æo * L}                                                */
/* assign tt-param.desc-classifica:label in frame f-parametros = trim(return-value). */
/*                                                                                   */
/* {utp/ut-liter.i Atualiza‡Æo Estabelecimentos / Itens * L}                         */
/* assign c-titulo-relat = trim(return-value).                                       */

/****************************** E X E C U € Ç O **********************************/
FIND FIRST tt-param NO-LOCK NO-ERROR.

{include/i-rpcab.i}
{include/i-rpout.i}

find first param-global no-lock no-error.
find first empresa
    where empresa.ep-codigo = param-global.empresa-prin no-lock no-error. 

if  avail empresa then
    assign c-empresa = empresa.razao-social.

assign c-programa = "ESP1006"
       c-versao   = "1.00"
       c-revisao  = "000".

{utp/ut-liter.i Resultado_do_Processamento * r}
assign c-sistema = trim(return-value).
{utp/ut-liter.i Gera‡Æo_Declara‡Æo_Importa‡Æo_Autom tica * r}
assign c-titulo-relat = trim(return-value).

/********************************* In¡cio do Programa *******************************/  
view frame f-cabec.
view frame f-rodape.


ASSIGN c-mensagem = "DI Gerada com sucesso".

   FOR FIRST tt-decla-import NO-LOCK: 
     DISP tt-decla-import.num-di-ems
          tt-decla-import.cod-estab 
          c-mensagem WITH FRAME f-geradas.
       DOWN WITH FRAME f-geradas.       
   END.

   /* imprime os erros na geracao da DI */
   ASSIGN c-linha = FILL("-",132).
   IF CAN-FIND(FIRST tt-erro-relat) THEN
       VIEW FRAME f-cabecErro.
   FOR EACH tt-erro-relat:
       EMPTY TEMP-TABLE tt-editor.
       ASSIGN c-erro = TRIM(tt-erro-relat.msg-erro).
       RUN pi-print-editor(c-erro, 129).
       FOR EACH tt-editor:
           PUT UNFORMATTED tt-editor.conteudo FORMAT "X(132)" AT 001.
       END.
       PUT UNFORMATTED SKIP(1).
   END.
   /* fim - imprime os erros na geracao da DI */

RUN pi-finalizar IN h-acomp.


procedure pi-print-editor:
    def input param c-editor    as char    no-undo.
    def input param i-len       as integer no-undo.

    def var i-linha  as integer no-undo.
    def var i-aux    as integer no-undo.
    def var c-aux    as char    no-undo.
    def var c-ret    as char    no-undo.

    for each tt-editor:
        delete tt-editor.
    end.

    assign c-ret = chr(255) + chr(255).

    do  while c-editor <> "":
        if  c-editor <> "" then do:
            assign i-aux = index(c-editor, chr(10)).
            if  i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then
                assign i-aux = r-index(c-editor, " ", i-len + 1).
            if  i-aux = 0 then
                assign c-aux = substr(c-editor, 1, i-len)
                       c-editor = substr(c-editor, i-len + 1).
            else
                assign c-aux = substr(c-editor, 1, i-aux - 1)
                       c-editor = substr(c-editor, i-aux + 1).
            if  i-len = 0 then
                assign entry(1, c-ret, chr(255)) = c-aux.
            else do:
                assign i-linha = i-linha + 1.
                create tt-editor.
                assign tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            end.
        end.
        if  i-len = 0 then
            return c-ret.
    end.
    return c-ret.
end procedure.

{include/i-rpclo.i}

RETURN "OK":U.        

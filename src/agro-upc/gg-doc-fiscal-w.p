/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-DOC-FISCAL-W 2.00.00.005 } /*** "010005" 29/05/2025 09:23:32  ***/


/***********************************************************************
**  Programa...: agro-upc/gg-doc-fiscal-w.p
**  Descricao..: 
**  data.......: jan/2007
************************************************************************/

DEFINE PARAM BUFFER b-doc-fiscal     FOR doc-fiscal.
DEFINE PARAM BUFFER b-old-doc-fiscal FOR doc-fiscal.

/* LOG339640 - O C‡DIGO FONTE DA VERSAO 1 FOI REMOVIDO POR SE TRATAR DE 
UM ESPEC÷FICO

FUNÄ«O ANTIGA: QUANDO TEMOS VARIOS ESTABELECIMENTOS EMITINDO NOTAS PARA 
O MESMO ARMAZEM, TEMOS UM PROBLEMA. OS ESTABELECIMENTOS PODEM UTILIZAR 
A MESMA SêRIE, NATUREZA DE OPERAÄ«O E NUMERAÄ«O DE NOTA FISCAL. O CLIENTE 
TAMBêM ê O MESMO POIS A EMPRESA APENAS ESTARµ ARMAZENANDO SUA MERCADORIA 
EM UM MESMO ARMAZEM. QUANDO CHEGA NA SALDO-TERC ESTµ O PROBLEMA, POIS ELA 
N«O ê POR ESTABELECIMENTO. OU SEJA, O MESMO ARMAZEM RECEBE NOTAS COM A 
MESMA CHAVE (NRO/NAT-OPER/SERIE/EMITENTE) DE VARIOS ESTABELECIMENTOS.
COMO SOLUÄ«O UMA LETRA FOI INSERIDA NO FINAL DO CAMPO CORRESPONDENTE A 
SERIE, POREM ESSA LETRA GERARIA PROBLEMAS EM DOIS MOMENTOS: IMPRESS«O DA 
NOTA (ESPECIFICO CUSTOMIZADO NO CLIENTE E EM OF). FOI CRIADO O ESPEC÷FICO 
DA VERSAO 1 DESSE PROGRAMA PARA VOLTAR A SêRIE DO DOCUMENTO EM OF PARA A 
SERIE ORIGINAL, OU SEJA, SEM A LETRA.*/

FIND FIRST docum-est NO-LOCK
     WHERE docum-est.serie-docto        = b-doc-fiscal.serie
       AND docum-est.nro-docto    = b-doc-fiscal.nr-doc-fis
       AND docum-est.cod-emitente = b-doc-fiscal.cod-emitente
       AND docum-est.nat-operacao = b-doc-fiscal.nat-operacao NO-ERROR.

IF AVAIL docum-est THEN DO:

    FIND FIRST gg-inscricao NO-LOCK
         WHERE gg-inscricao.cod-inscricao = integer(docum-est.cod-entrega)
         AND   gg-inscricao.cod-emitente  = docum-est.cod-emitente NO-ERROR.

    IF AVAIL gg-inscricao THEN
        ASSIGN b-doc-fiscal.cgc          = gg-inscricao.cgc
               b-doc-fiscal.ins-estadual = gg-inscricao.ins-estadual.
END.

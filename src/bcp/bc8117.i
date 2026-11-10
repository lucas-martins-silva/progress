/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: bc8117.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Embalag para 
**               o BC
**
**   Autor.....: Marcio Roberto Andrade - Fev/2001
*********************************************************************************/

/**********************************  bc8117.i  **********************************/
DEFINE TEMP-TABLE ttParamEmbalag NO-UNDO
    FIELD embalagem-ini    AS CHARACTER LABEL 'Embalagem Inicial'
    FIELD embalagem-fim    AS CHARACTER LABEL 'Embalagem Final'
    FIELD sigla-emb-ini    AS CHARACTER LABEL 'Sigla Embalagem Inicial'
    FIELD sigla-emb-fim    AS CHARACTER LABEL 'Sigla Embalagem Final'
    FIELD descricao-ini    AS CHARACTER LABEL 'Descriá∆o Inicial'
    FIELD descricao-fim    AS CHARACTER LABEL 'Descriá∆o Final'
    FIELD acess-mode       AS INTEGER   LABEL 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    FIELD num-of-rec       AS INTEGER   LABEL 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    FIELD record-phrase    AS INTEGER   LABEL 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttEmbalag NO-UNDO
    FIELD Embalagem        AS CHARACTER LABEL 'Embalagem'
    FIELD Sigla-Emb        AS CHARACTER LABEL 'Sigla Embalagem'
    FIELD Descricao        AS CHARACTER LABEL 'Descriá∆o'
    FIELD rowid-value      AS ROWID   
        INDEX mblgm  Embalagem
        INDEX sglmb  Sigla-Emb
        INDEX dscrc  descricao.

DEFINE FRAME fttEmbalag
        ttEmbalag
        with STREAM-IO.
DEFINE FRAME fttParamEmbalag
        ttParamEmbalag
        with STREAM-IO.
/**********************************  bc8117.i  **********************************/

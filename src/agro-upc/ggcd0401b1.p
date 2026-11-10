/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0401B1 2.00.00.004 } /*** 010004 ***/


/*************************************************************************
**    Programa.: GGCD0401B
**    Objetivo.: UPC de Leave no campo Conjuge do GGCD0401B.
**    Data.....: Outubro de 2006
*************************************************************************/
/******************* Definicao de Variaveis Globais **********************/
DEF NEW GLOBAL SHARED VAR wh-conjuge-cd0401b      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cpf-cd0401b          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rg-cd0401b           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-orgao-cd0401b        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-estado-cd0401b       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-area-cd0401b         AS WIDGET-HANDLE NO-UNDO.

/************************** In¡cio do Programa ***************************/
IF wh-conjuge-cd0401b:CHECKED THEN DO:
   ASSIGN wh-cpf-cd0401b   :SENSITIVE    = YES
          wh-rg-cd0401b    :SENSITIVE    = YES
          wh-orgao-cd0401b :SENSITIVE    = YES
          wh-estado-cd0401b:SENSITIVE    = YES.
   APPLY "ENTRY":U TO wh-cpf-cd0401b.
END.
ELSE
   ASSIGN wh-cpf-cd0401b   :SENSITIVE    = NO
          wh-rg-cd0401b    :SENSITIVE    = NO
          wh-orgao-cd0401b :SENSITIVE    = NO
          wh-estado-cd0401b:SENSITIVE    = NO
          wh-cpf-cd0401b   :SCREEN-VALUE = "":U
          wh-rg-cd0401b    :SCREEN-VALUE = "":U
          wh-orgao-cd0401b :SCREEN-VALUE = "":U
          wh-estado-cd0401b:SCREEN-VALUE = "":U.

/* fim - ggcd0401b1.p */

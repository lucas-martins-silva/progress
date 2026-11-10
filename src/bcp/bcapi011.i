/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************
** Include: API011.I
** Objetivo: Defini‡Æo da temp-table do BCPAPI011.P
*******************************************************************/

def temp-table tt-etq-item NO-UNDO
    field qt-item               as  dec decimals 4 format ">>>>>>>>>>>>>.9999"
    field it-codigo             as  char
    field qt-etiqueta           as  dec
    field qt-etiq-item          as  dec decimals 4 format ">>>>>>>>>>>>>.9999"
    field qt-ult-etiqueta       as  dec decimals 4 format ">>>>>>>>>>>>>.9999"
    field tipo-etiq             as  int
    field cd-trans              as  char format "X(08)"
    field nome-abrev            as  char format "X(12)"
    field tipo-etiq-total       as  int
    field qt-etiqueta-total     as  dec
    field qt-etiq-total         as  dec decimals 4 format ">>>>>>>>>>>>>.9999"
    field qt-ult-etiq-total     as  dec decimals 4 format ">>>>>>>>>>>>>.9999"
    field it-codigo-ext-1       as  char format "X(16)"
    field it-codigo-ext-2       as  char format "X(16)"
    field it-codigo-ext-3       as  char format "X(16)"
    field it-codigo-ext-4       as  char format "X(16)"
    field cod-versao-integracao as  int.

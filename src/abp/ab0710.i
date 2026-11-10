/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0710.i
**
**       DATA....: Julho de 2007
**
**       AUTOR...: Daniel Marquini - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Include de Defini‡Æo de Temp-Tables AB0710
**
*****************************************************************************/
define temp-table tt-param no-undo
  field destino          as integer
  field arquivo          as character format "x(35)":U
  field usuario          as character format "x(12)":U
  field data-exec        as date
  field hora-exec        as integer
  field classifica       as integer
  field desc-classifica  as character format "x(40)":U
  field modelo           as character format "x(35)":U
  /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
  field l-habilitaRtf    as logical
  field arq-entrada      as character
  field arq-destino      as character
  field todos            as integer
  /*Fim alteracao 15/02/2005*/
  field InputFolder      as character format "x(80)".

define temp-table tt-raw-digita
 field raw-digita      as raw.

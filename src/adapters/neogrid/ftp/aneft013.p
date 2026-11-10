/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT013 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEFT013 MFT}
&ENDIF


/********************************************************************************
** Programa : aneft013.p
** Fun»’o   : Sender de Cidades Zona Franca Manaus
** Data     : 09/206
** Autor    : Eliza F. Corrˆa
********************************************************************************/

{adapters/neogrid/include/anein004.i}

DEF VAR c-root                       AS CHAR. 
DEF VAR c-message                    AS CHAR.
DEF VAR c-campo                      AS CHAR.
DEF VAR c-ZonaFrancaCity             AS CHAR.
DEF VAR c-CityInformationCollection  AS CHAR.
DEF VAR c-CityInformation            AS CHAR.
DEF VAR c-FromRole                   AS CHAR NO-UNDO.
DEF VAR c-ToRole                     AS CHAR NO-UNDO.

RUN pi-cabecalho-msg.

FOR EACH cidade-zf NO-LOCK:
    RUN pi-corpo-msg.
END.


WRITExml().

RETURN "OK":U.

/* PROCEDURES */
PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("ZonaFrancaCity":U,"1.01.001":U,"1":U)
             c-message = AddElement(c-root,"Message":U)
               c-ZonaFrancaCity = AddElement(c-message,"ZonaFrancaCity":U)
                 c-CityInformationCollection = AddElement(c-ZonaFrancaCity,"CityInformationCollection":U)
                 c-FromRole = AddElement(c-ZonaFrancaCity,"FromRole":U)
                 c-ToRole = AddElement(c-ZonaFrancaCity,"ToRole":U).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-corpo-msg:
    ASSIGN c-CityInformation = AddElement(c-CityInformationCollection,"CityInformation":U)
             c-campo = AddEleChar(c-CityInformation,"CityName":U,cidade-zf.cidade)
             c-campo = AddEleChar(c-CityInformation,"StateCode":U,cidade-zf.estado)
             c-campo = AddEleInt(c-CityInformation,"ZonaFrancaCode":U,cidade-zf.int-1).

    RETURN "OK":U.
END PROCEDURE.




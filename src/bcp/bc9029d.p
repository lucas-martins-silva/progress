/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9029D 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9029d MBC}
&ENDIF


{include/i_dbvers.i}  /* versao das bases e bases instaladas */
&if '{&mgscm_version}' >= '2.04' &then

/* ************************************************************************** */
/*     Programa...: bc9029d.p                                                 */
/*                                                                            */
/*     Criado em..: Abril 2005                                                */
/*                                                                            */
/*     Versao.....: 1.00.00.000 Paulo Eduardo Budal                           */
/* ************************************************************************** */

/* ************************** Includes ***************************************** */

{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
{method/dbotterr.i}

Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.

/**************************** Definitions ****************************************/
def temp-table tt-etiqueta no-undo
    field id-etiqueta    like wm-etiqueta.id-etiqueta
    field qtd-retirada   like wm-etiqueta.qtd-item 
    index codigo is unique id-etiqueta.

DEF TEMP-TABLE tt-tarefa-docto NO-UNDO
    FIELD CodUsuario     LIKE wm-tarefa-docto-itens.cod-usuario     
    FIELD CodEquipamento LIKE wm-tarefa-docto-itens.cod-equipamento 
    FIELD CodColetor     LIKE wm-tarefa-docto-itens.cod-coletor     
    FIELD TempoInicio    AS INTEGER.

DEFINE VARIABLE HDbosc032            AS HANDLE                     NO-UNDO.
DEFINE VARIABLE HDbosc038            AS HANDLE                     NO-UNDO.
DEFINE VARIABLE HDbosc047            AS HANDLE                     NO-UNDO.
DEFINE VARIABLE rWm-box-movto        AS ROWID                      NO-UNDO.
DEFINE VARIABLE c-des-seriais        AS CHARACTER FORMAT "x(100)"  NO-UNDO.
DEFINE VARIABLE i-pos-etq            AS INTEGER                    NO-UNDO.
DEFINE VARIABLE l-reutiz-etiq-docto  AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-reutiliza-etiqueta AS LOGICAL                    NO-UNDO.

/*********************************************************************************/

RUN scbo/bosc032.p PERSISTEN SET hDBosc032.
RUN OpenQueryStatic IN hDBosc032 (INPUT "Main":U) NO-ERROR.

RUN scbo/bosc038.p PERSISTEN SET hDBosc038.
RUN OpenQueryStatic IN hDBosc038 (INPUT "Main":U) NO-ERROR.

RUN scbo/bosc047.p PERSISTEN SET hDBosc047.
RUN OpenQueryStatic IN hDBosc047 (INPUT "Main":U) NO-ERROR.
                                    
RUN verificarReutilizaEtiqMovto IN hDBosc047 ( INPUT _RetornaValChar("Cod-estabel"),
                                               INPUT _RetornaValChar("Cod-local"),
                                               INPUT _RetornaValDeci("id-movto"),
                                               INPUT _RetornaValDeci("num-serial"),
                                               OUTPUT l-reutiliza-etiqueta).

RUN gotoKey2 IN hDBosc032(INPUT _RetornaValChar("Cod-estabel"),
                          INPUT _RetornaValChar("Cod-local"),
                          INPUT _RetornaValDeci("id-movto"),
                          INPUT 1).

RUN getRowid IN hDBosc032(OUTPUT rWm-box-movto).

IF VALID-HANDLE(hDBosc038) THEN DO:
   RUN setConstraintIdDocto IN hDBosc038 (INPUT _RetornaValChar("Cod-estabel"),
                                          INPUT _RetornaValChar("Cod-local"),
                                          INPUT _RetornaValDeci("id-docto"),
                                          INPUT _RetornaValDeci("id-docto"),
                                          INPUT 0,   /* ind-tipo-trans */
                                          INPUT 99,  /* ind-tipo-trans */
                                          INPUT 0,   /* ind-origem-docto */
                                          INPUT 99). /* ind-origem-docto */

   RUN openQueryStatic IN hDBosc038 (INPUT "IdDocto":U).
   RUN goToKey IN hDBosc038 ( INPUT _RetornaValChar("Cod-estabel"),
                              INPUT _RetornaValChar("Cod-local"),
                              INPUT ?,
                              INPUT _RetornaValDeci("id-docto")).

   RUN getLogField IN HDbosc038 (INPUT "log-reutiliz-etiq":U,
                                 OUTPUT l-reutiz-etiq-docto).
END.

RUN Destroy IN HDbosc032.
RUN Destroy IN hDBosc038.
RUN Destroy IN hDBosc047.

ASSIGN c-des-seriais = _RetornaValChar("cod-livre-1").

IF c-des-seriais <> "" THEN DO:
    DO i-pos-etq = 1 TO NUM-ENTRIES(c-des-seriais,";"):  
       CREATE tt-etiqueta.
       ASSIGN tt-etiqueta.id-etiqueta = DECIMAL(ENTRY(i-pos-etq, c-des-seriais,";")).
    END.
END.
ELSE DO:
    CREATE tt-etiqueta.
    ASSIGN tt-etiqueta.id-etiqueta = _RetornaValDeci("num-serial").
END.

CREATE tt-tarefa-docto.
ASSIGN tt-tarefa-docto.codusuario     = _RetornaValChar("cod-usuario")
       tt-tarefa-docto.codequipamento = _RetornaValChar("cod-equipamento")
       tt-tarefa-docto.codcoletor     = _RetornaValChar("cod-coletor")
       tt-tarefa-docto.TempoInicio    = _RetornaValInte("horario-inicio").

FOR EACH rowerrors:
    DELETE rowerrors.
END.
FOR EACH tt-erro:
    DELETE tt-erro.
END.

IF l-reutiz-etiq-docto = YES AND l-reutiliza-etiqueta = YES THEN DO:
   /* executa entrada */
    RUN wmp/wm9031a.p (INPUT rWm-box-movto,
                       INPUT _RetornaValInte("num-box"),
                       INPUT 2, /*Coletor*/
                       INPUT TABLE tt-etiqueta,
                       INPUT TABLE tt-tarefa-docto,
                       OUTPUT TABLE RowErrors).
END.
ELSE DO:  
   /* executa entrada */
    RUN wmp/wm9031.p (INPUT rWm-box-movto,
                      INPUT _RetornaValInte("num-box"),
                      INPUT TABLE tt-etiqueta,
                      INPUT TABLE tt-tarefa-docto,
                      OUTPUT TABLE RowErrors).
END. 

FIND FIRST RowErrors NO-LOCK NO-ERROR.
IF AVAIL RowErrors THEN DO:

    FOR EACH RowErrors:
       CREATE tt-erro.
       ASSIGN tt-erro.cd-erro  = RowErrors.ErrorNumber
              tt-erro.mensagem = RowErrors.ErrorDescription.
    END.
    RETURN "NOK":U.

END.

/* API para cria‡Æo do historico da etiqueta */
RUN bcp/bcapi9000.p (INPUT pNumTrans,
                     INPUT string(tt-etiqueta.id-etiqueta),
                     INPUT "").

RETURN "OK".
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif

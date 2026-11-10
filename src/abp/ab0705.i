/*************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0705.i
**
**       DATA....: Maráo de 2005
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: Importaá∆o Abastecimentos/Lubrificaá‰es
**       Versao..: 
**
**************************************************************************/
                                                   /** Definiá∆o vari†veis **/
DEFINE VARIABLE c-liter-par    AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-liter-sel    AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-liter-log    AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-destino      AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-imprime      AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-execucao     AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-tit-linha    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-emp      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-eqpto    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-data     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-km       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-erro     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-placa    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-liter-un     AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE cUnidNegocIni  AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cUnidNegocFim  AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cFaixa         AS CHARACTER FORMAT "x(06)" INITIAL "|<  >|" NO-UNDO.
/**********************************************************************/
{abp/ab9004.i}             /** Temp-table RowErrors **/
{cdp/cdcfgmnt.i}


/** Erros de Importaá∆o **/
define temp-table RowErrorsAux no-undo like RowErrors
    field i-linha as integer.


define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field todos            as integer  /** 1 = Todos / 2 = Rejeitados **/
    field execucao         as integer
    field i-origem         as integer
    field arq-entrada      as char format "x(80)"
    field arq-destino      as char format "x(80)"
    field dtInicial        as date format "99/99/9999"
    field dtFinal          as date format "99/99/9999"
&IF "{&mguni_version}" >= "2.071" &THEN
    field empIni           LIKE empresa.ep-codigo
    field empFim           LIKE empresa.ep-codigo
&ELSE
    field empIni           as integer format ">>9"
    field empFim           as integer format ">>9"
&ENDIF
    field eqptoIni         as character format "x(16)"
    field eqptoFim         as character format "x(16)"
    field placaIni         as character format "x(8)"
    field placaFim         as character format "x(8)"
    field cDelimitador     as character format "x(1)"
    field iLayout          as integer
    field iImport          as integer
    field iClassif         as integer
    field iAgrupa          as integer
    field lValoresPadr     as logical
    field cLayout          as character
    field cImport          as character format "x(20)"
    field cClassif         as character
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-prin          LIKE empresa.ep-codigo
&ELSE
    field ep-prin          as integer format ">>9"
&ENDIF
&IF DEFINED(bf_mnt_ems206b) &THEN
    FIELD unidNegocIni     AS CHARACTER FORMAT "x(03)"
    FIELD unidNegocFim     AS CHARACTER FORMAT "x(03)"
&ENDIF
    .



define temp-table ttRegistros no-undo
    FIELD nombre                AS CHAR
    FIELD patente               AS CHAR
    FIELD vehiculo              AS CHAR
    FIELD tarjeta               AS INT
    FIELD fecha                 AS DATE
    FIELD hora                  AS CHAR
    FIELD estacion-de-servicio  AS CHAR
    FIELD guia-despacho         AS CHAR
    FIELD p-unitario            AS DECIMAL
    FIELD volumen               AS DECIMAL
    FIELD monto                 AS DECIMAL
    FIELD odometro              AS DECIMAL
    FIELD Km-Lt                 AS DECIMAL
    FIELD Km                    AS DECIMAL
    field iTipo                 as integer
    field Tipo                  as integer
    field ep-codigo             like mab-eqpto.ep-codigo
    field desc-empresa          like empresa.nome
    field cod-eqpto             like mab-eqpto.cod-eqpto
    field num-docto             like mab-abastec-lubrific.num-docto
    FIELD ep-codigo-matr        LIKE mab-motoris.ep-codigo
    FIELD cod-estabel-matr      LIKE mab-motoris.cod-estabel
    field cod-matr              like mab-motoris.cod-matr
    field cod-placa             like mab-eqpto.cod-placa
    field cod-posto             like mab-posto.cod-posto
    field cod-bomba             like mab-bomba.cod-bomba 
    field cod-tip-mater         like mab-item-abastec.cod-tip-mater
    field des-tip-mater         like mab-tip-mater.des-tip-mater
    field val-hodom-horim       like mab-abastec-lubrific.val-hodom-horim
    field val-quant             like mab-item-abastec.val-quant
    field val-mater-1           like mab-item-abastec.val-mater-1
    field val-mater-2           like mab-item-abastec.val-mater-2
    field val-mater-3           like mab-item-abastec.val-mater-3
    field val-dat-hora-invrt    as char
    field tip-troca             as integer
    field valDatHorInvert       like mab-abastec-lubrific.val-dat-hora-invrtda
    field cod-emitente          like emitente.cod-emitente
    field cgc                   like emitente.cgc
    field cc-codigo             like mab-eqpto.cc-codigo
    field cod-mater             like mab-tip-mater-item.cod-tip-mater
    field dat-movto             like mab-abastec-lubrific.dat-movto
    field hra-inicial           like mab-abastec-lubrific.hra-inicial
    field nr-nota-fis           like mab-abastec-lubrific.nr-nota-fis
    field des-posto             like mab-posto.des-posto
    field cod-comptmento        like mab-comptmento.cod-comptmento
    FIELD log-abastec-prim      LIKE mab-item-abastec.log-abastec-prim
    FIELD nr-trans              LIKE mab-item-abastec.nr-trans
    field cod-evento            like mab-event.cod-event
    field des-model             like mab-model.des-model
    field cod-usuar             like mab-abastec-lubrific.cod-usuar
    FIELD cod-usuar-alter       LIKE mab-abastec-lubrific.cod-usuar-alter
    FIELD dat-origin            LIKE mab-abastec-lubrific.dat-origin
    FIELD dsl-obs               LIKE mab-abastec-lubrific.dsl-obs
    field cod-refer             like mab-item-abastec.cod-refer
    field cod-localiz           like mab-item-abastec.cod-localiz
    field lote                  like mab-item-lubrific.lote
    field serie                 like mab-abastec-lubrific.serie
&IF DEFINED(bf_mnt_ems206b) &THEN
    field cod-unid-negoc        like mab-abastec-lubrific.cod-unid-negoc
&ELSE
    field cod_unid_negoc        like mab-abastec-lubrific.cod_unid_negoc
&ENDIF
    field nom-motoris           like mab-motoris.nom-motoris 
    field it-codigo             like mab-tip-mater-item.it-codigo
    field cod-ativid            like mab-ativid.cod-ativid
    field cd-tipo               like mab-item-lubrific.cd-tipo
    field ct-codigo             like mab-eqpto.ct-codigo
    field cod-rota              like mab-trajeto.cod-rota
    FIELD val-hodom-horim-sec   LIKE mab-abastec-lubrific.val-hodom-horim-sec
    /**Estes campos s∆o para o layout do CTF  **/
    field apontador             as integer
    field num-abastec           as integer
    field tp-regist             as integer
    field icod-veiculo          as integer
    field icod-bomba            as integer
    field icod-rede             as integer
    field icod-posto            as integer
    field icod-frota            as integer
    field cTpCombust            as char
    field uve                   as char
    field val-descont           like mab-item-abastec.val-mater-1
    field val-tot               like mab-item-abastec.val-mater-1
    field dat-credit            as date
    field cNomeArq              as char
    field deDistPerc            as decimal
    field val-qtde-tot          as integer
    field cStatus               as char
    field val-abastec-ant       like mab-item-abastec.val-quant
    field cCidPosto             as char format "x(40)"
    field iLinha                as integer 
    field l-agrupa              as logical initial no
	field log-erro-segur        as logical initial no
    field ct-codigo-ficha-lubrific LIKE mab-eqpto.ct-codigo
    field cc-codigo-ficha-lubrific LIKE mab-eqpto.cc-codigo
    field ct-codigo-lubrific    like mab-eqpto.ct-codigo
    field cc-codigo-lubrific    like mab-eqpto.cc-codigo
    FIELD ct-codigo-abastec     LIKE mab-eqpto.ct-codigo
    FIELD cc-codigo-abastec     LIKE mab-eqpto.cc-codigo
    index iDocto                num-docto 
    index valdatahora           iLinha
                                ep-codigo
                                cod-eqpto
                                cod-matr
                                valDatHorInvert.



                                                      /** Frame ParÉmetros **/
DO:
form /*PAR∂METRO*/
     skip(1)
     c-liter-par     AT 09       NO-LABEL
     skip(1)
     tt-param.arq-entrada  COLON 30 
     /*SELEÄ«O*/
     skip(1)
     c-liter-sel     AT 09       NO-LABEL
     skip(1)
     tt-param.dtInicial   COLON 30  "|<  >|" AT 50
     tt-param.dtFinal     NO-LABEL                
     tt-param.empIni      COLON 30  "|<  >|" AT 50
     tt-param.empFim      NO-LABEL                
     tt-param.eqptoIni    COLON 30  "|<  >|" AT 50
     tt-param.eqptoFim    NO-LABEL                
     tt-param.placaIni    COLON 30  "|<  >|" AT 50
     tt-param.placaFim    NO-LABEL                   
     &IF DEFINED(bf_mnt_ems206b) &THEN
     c-liter-un    COLON 13   NO-LABEL 
     cUnidNegocIni COLON 30   NO-LABEL cFaixa NO-LABEL AT 50 
     cUnidNegocFim            NO-LABEL
     &ENDIF
    /*LOG*/
     skip(1)   
     c-liter-log     AT 09       no-label
     skip(1)
     c-imprime             colon 30  
     c-destino             colon 30 " - " tt-param.arq-destino NO-LABEL
     c-execucao            colon 30
     tt-param.usuario      colon 30
     tt-param.iLayout      colon 30 " - " tt-param.cLayout    NO-LABEL
     tt-param.iImport      colon 30 " - " tt-param.cImport    NO-LABEL
     tt-param.iClassif     colon 30 " - " tt-param.cClassif   NO-LABEL
     skip(1)        
     with width 132 side-labels frame f-param-definidos stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-definidos:HANDLE).

END. 
/**********************************************************************/
                                                   /** Literais ParÉmetros **/
{utp/ut-liter.i "Data Inicial"}
assign tt-param.dtInicial:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Empresa"}
assign tt-param.empIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Equipamento"}
assign tt-param.eqptoIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Placa"}
assign tt-param.placaIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Usu†rio" * l}
assign tt-param.usuario:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Entrada" * l}
assign tt-param.arq-entrada:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Tipo Layout" * l}
assign  tt-param.iLayout:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Tipo Importaá∆o" * l}
assign tt-param.iImport:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Importa Por" * l}
assign tt-param.iClassif:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Destino" * l}
assign c-destino:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Imprime" * l}
assign c-imprime:label in frame f-param-definidos = return-value. 
{utp/ut-liter.i "Todos,Rejeitados" *} /*
assign c-imprime = entry(tt-param.todos,return-value).*/
{utp/ut-liter.i "Execuá∆o" * l} 
assign c-execucao:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "On-Line,Batch" *} /*
assign c-execucao = entry(tt-param.execucao,return-value).*/
{utp/ut-liter.i "PAR∂METROS" * R}
assign c-liter-par = return-value.
{utp/ut-liter.i "SELEÄ«O" * R}
assign c-liter-sel = return-value.
{utp/ut-liter.i "LOG" * R}
assign c-liter-log = return-value.
{utp/ut-liter.i Unidade_Neg¢cio: * R}
assign c-liter-un = trim(return-value).
/**********************************************************************/     
                                                       /** Frame Impress∆o **/
form ttRegistros.iLinha    space(8)
     ttRegistros.ep-codigo 
     ttRegistros.cod-eqpto 
     ttRegistros.dat-movto 
     ttRegistros.cod-placa 
     RowErrorsAux.ErrorNumber
     RowErrorsAux.ErrorDescription format "x(60)"
    with width 132 no-attr-space no-box NO-LABELS down frame f-km stream-io.
/**********************************************************************/
                                                /** Frame T°tulo Impress∆o **/
form c-tit-linha
     c-tit-emp
     c-tit-eqpto  format "x(16)"
     c-tit-data   format "x(10)"
     c-tit-placa  format "x(10)"
     c-tit-erro   format "x(65)"
     SKIP
    with width 132 no-attr-space NO-BOX PAGE-TOP TOP-ONLY frame f-titulo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-titulo:HANDLE).

/**********************************************************************/
                                             /** Literais Titulo Impress∆o **/
{utp/ut-liter.i "Linha" * l}
assign c-tit-linha:label in frame f-titulo = return-value.
{utp~/ut-liter.i "Empresa" * l}
assign c-tit-emp:label in frame f-titulo = return-value
       tt-param.empIni:label in frame f-param-definidos = return-value.
{utp~/ut-liter.i "Equipamento" * l}
assign c-tit-eqpto:label in frame f-titulo = return-value.
{utp~/ut-liter.i "Movimento" * l}
assign c-tit-data:label in frame f-titulo = return-value.
{utp~/ut-liter.i "Erro" * l}
assign c-tit-erro:label in frame f-titulo = return-value.
{utp~/ut-liter.i "Placa" * l}
assign c-tit-placa:label in frame f-titulo = return-value.

/**********************************************************************/
                                                           /** Frame Erros **/
form RowErrorsAux.ErrorSequence    at 5
     RowErrorsAux.ErrorNumber      
     RowErrorsAux.ErrorDescription format "x(60)"
    with width 132 no-attr-space no-box down frame f-erro stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).


{utp~/ut-liter.i "Seq."}
assign RowErrorsAux.ErrorSequence:label in frame f-erro = trim(return-value).
{utp~/ut-liter.i "Erro"}
assign RowErrorsAux.ErrorNumber:label in frame f-erro = trim(return-value).
{utp~/ut-liter.i "Descriá∆o"}
assign RowErrorsAux.ErrorDescription:label in frame f-erro = trim(return-value).
/**********************************************************************/
                                            /** Final da include de frames **/
